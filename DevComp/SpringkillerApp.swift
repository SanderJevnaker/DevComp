import SwiftUI
import Sparkle

@main
struct SpringkillerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            // settings content here
        }
        .commands {
            // custom commands here
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuManager: MenuManager?
    var updater: SUUpdater!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menuManager = MenuManager()
        NSApp.setActivationPolicy(.accessory)
        self.updater = SUUpdater.shared()
        
    }
}
