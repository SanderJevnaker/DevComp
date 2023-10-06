import Foundation
import SwiftUI
import Cocoa
import AppKit


class MenuManager: NSObject {
    var statusItem: NSStatusItem?
    var preferencesWindowController: PreferencesWindowController?
    var base64WindowController: NSWindowController?
    var vpnConfigWindowController: VPNConfigWindowController?
    
    var vpnManager: VPNManager
    var encodeManager: EncodeManager
    var scriptManager: ScriptManager


    override init() {
        self.vpnManager = VPNManager()
        self.encodeManager = EncodeManager()
        self.scriptManager = ScriptManager()
        super.init()
        
        DispatchQueue.main.async {
            self.setupMenu()
        }
    }
    
    func setupMenu() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = self.statusItem?.button {
            if let image = NSImage(named: "icon") {
                image.isTemplate = true
                button.image = image
            }
        }
        
        let menu = NSMenu()
        let killItem = NSMenuItem(title: "Kill running Springboot services", action: #selector(self.killSpringboot), keyEquivalent: "")
        let startDevModeItem = NSMenuItem(title: "Start developer mode", action: #selector(self.startDevMode), keyEquivalent: "")
        let preferencesItem = NSMenuItem(title: "Settings", action: #selector(self.openPreferences), keyEquivalent: ",")
        let base64Item = NSMenuItem(title: "Encode/Decode", action: #selector(self.openEncoder), keyEquivalent: "")
        let vpnConfigItem = NSMenuItem(title: "VPN Configuration", action:#selector(self.openVPNConfigWindow), keyEquivalent: "")
        let connectVPNItem = NSMenuItem(title: "Connect to VPN", action: #selector(self.connectVPN), keyEquivalent: "")
        let disconnectVPNItem = NSMenuItem(title: "Disconnect from VPN", action: #selector(self.disconnectVPN), keyEquivalent: "")
        let aboutItem = NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: "")

        startDevModeItem.target = self
        preferencesItem.target = self
        killItem.target = self
        base64Item.target = self
        vpnConfigItem.target = self
        connectVPNItem.target = self
        disconnectVPNItem.target = self
        aboutItem.target = self
        
        menu.addItem(killItem)
        menu.addItem(base64Item)
        menu.addItem(connectVPNItem)
        menu.addItem(disconnectVPNItem)
        menu.addItem(vpnConfigItem)
        menu.addItem(startDevModeItem)
        menu.addItem(preferencesItem)
        menu.addItem(aboutItem)
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.statusItem?.menu = menu
    }

    @objc func startDevMode() {
        let viewModel = PreferencesViewModel()
        print("Apps to open: \(viewModel.startDevModeApps)")
        
        for appName in viewModel.startDevModeApps {
            if let encodedAppName = appName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
               let url = URL(string: "file:///Applications/\(encodedAppName).app") {
                print("Attempting to open URL: \(url)")
                
                DispatchQueue.main.async {
                    let config = NSWorkspace.OpenConfiguration()
                    NSWorkspace.shared.openApplication(at: url, configuration: config) { (app, error) in
                        if let error = error {
                            print("Failed to open \(url): \(error)")
                        } else {
                            print("Successfully opened \(url)")
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func openPreferences() {
        NSApp.activate(ignoringOtherApps: true)
        self.preferencesWindowController = PreferencesWindowController()
        self.preferencesWindowController?.showWindow(nil)
    }
        
    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = "About DevComp"
        alert.informativeText = "Copyright Jevnaker Consulting"
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc func killSpringboot() {
        scriptManager.killSpringboot()
    }
    
    @objc func connectVPN() {
        vpnManager.connectVPN()
    }
    
    @objc func disconnectVPN() {
        vpnManager.disconnectVPN()
    }
    
    @objc func openVPNConfigWindow() {
        vpnManager.openVPNConfigWindow()
    }
    
    @objc func createVPNConfigFile() {
        vpnManager.createVPNConfigFile()
    }
    
    @objc func openEncoder() {
        encodeManager.openBase64Window()
    }
    
    
}
extension String {
    var nonEmpty: String? {
        return isEmpty ? nil : self
    }
}
