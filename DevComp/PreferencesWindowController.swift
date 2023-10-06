import Foundation
import SwiftUI
import Cocoa

class PreferencesWindowController: NSWindowController {
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 700, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        window.contentView = NSHostingView(rootView: PreferencesView())
        window.level = .floating
        self.init(window: window)

        if let screen = window.screen {
            let screenRect = screen.visibleFrame
            let newOrigin = NSPoint(x: screenRect.midX - window.frame.width / 2,
                                    y: screenRect.midY - window.frame.height / 2)
            window.setFrameOrigin(newOrigin)
        }
    }
}



extension UserDefaults {
    func set(_ value: [String], forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key)
    }

    func stringArray(forKey key: String) -> [String]? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode([String].self, from: data)
    }
}
