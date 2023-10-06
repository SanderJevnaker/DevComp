import Foundation
import SwiftUI
import Cocoa
import AppKit

class VPNManager {
    
    var vpnConfigWindowController: VPNConfigWindowController?
    
    
    func createVPNConfigFile() {
        let host = UserDefaults.standard.string(forKey: "VPNHost") ?? ""
        let port = UserDefaults.standard.string(forKey: "VPNPort") ?? ""
        let username = UserDefaults.standard.string(forKey: "VPNUsername") ?? ""
        let password = UserDefaults.standard.string(forKey: "VPNPassword") ?? ""
        let cert = UserDefaults.standard.string(forKey: "VPNCert") ?? ""

        let configFileContent = """
        host = \(host)
        port = \(port)
        username = \(username)
        password = \(password)
        realm = proxy
        trusted-cert = \(cert)
        """

        let filePath = NSString(string: "~/vpnConfig.conf").expandingTildeInPath

        do {
            try configFileContent.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("VPN configuration successfully saved to \(filePath)")
        } catch {
            print("An error occurred while writing the configuration file: \(error)")
        }
    }
    
    @objc func connectVPN() {
        createVPNConfigFile()

        let alert = NSAlert()
        alert.messageText = "Enter your sudo password"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")

        let passwordTextField = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        alert.accessoryView = passwordTextField

        let response = alert.runModal()
        if response == NSApplication.ModalResponse.alertFirstButtonReturn,
           let password = passwordTextField.stringValue.nonEmpty {
            let script = """
            echo '\(password)' | sudo -S /opt/homebrew/bin/openfortivpn -c ~/vpnConfig.conf
            """
            executeScript(script)
        }
    }
    
    @objc func openVPNConfigWindow() {
        NSApp.activate(ignoringOtherApps: true)
        let vpnConfigWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        vpnConfigWindow.title = "VPN Configuration"
        vpnConfigWindow.level = .floating

        vpnConfigWindow.contentView = NSHostingView(rootView: VPNConfigView())

         if let screen = vpnConfigWindow.screen {
            let screenRect = screen.visibleFrame
            let newOrigin = NSPoint(x: screenRect.midX - vpnConfigWindow.frame.width / 2,
                                    y: screenRect.midY - vpnConfigWindow.frame.height / 2)
            vpnConfigWindow.setFrameOrigin(newOrigin)
        }

        self.vpnConfigWindowController = VPNConfigWindowController(window: vpnConfigWindow)
        self.vpnConfigWindowController?.showWindow(nil)
    }
    
    @objc func disconnectVPN() {
        let script = """
        #!/bin/bash
        kill $(ps aux | grep '[o]penfortivpn' | awk '{print $2}')
        """
        executeScript(script)
    }
    
    func executeScript(_ script: String) {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", script]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        task.terminationHandler = { _ in
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            print("Task completed with output \(String(describing: output))")
        }
        
        do {
            try task.run()
        } catch {
            print("An error occurred: \(error)")
        }
    }
}
