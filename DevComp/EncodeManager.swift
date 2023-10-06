import Foundation
import SwiftUI
import Cocoa
import AppKit

class EncodeManager {
    var base64WindowController: NSWindowController?

    @objc func openBase64Window() {
        NSApp.activate(ignoringOtherApps: true)
        let base64Window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 200),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        base64Window.contentView = NSHostingView(rootView: Base64View())
        
        if let screen = base64Window.screen {
            let screenRect = screen.visibleFrame
            let newOrigin = NSPoint(x: screenRect.midX - base64Window.frame.width / 2,
                                    y: screenRect.midY - base64Window.frame.height / 2)
            base64Window.setFrameOrigin(newOrigin)
        }
        
        self.base64WindowController = NSWindowController(window: base64Window)
        self.base64WindowController?.showWindow(nil)
    }
}
