import SwiftUI
import Cocoa
import Foundation

class PreferencesViewModel: ObservableObject {
    @Published var startDevModeApps: [String] {
        didSet {
            // Save the new value to UserDefaults whenever it changes
            if let encoded = try? JSONEncoder().encode(startDevModeApps) {
                UserDefaults.standard.set(encoded, forKey: "startDevModeApps")
            }
        }
    }
    
    @Published var availableApps: [String] {
        didSet {
            let data = try? JSONEncoder().encode(availableApps)
            UserDefaults.standard.set(data, forKey: "availableAppsData")
        }
    }

    @Published var newAppName: String = ""
    @Published var newAppPath: String = ""

    init() {
        // Load the saved value from UserDefaults when the view model is initialized
        if let savedData = UserDefaults.standard.data(forKey: "startDevModeApps"),
           let decoded = try? JSONDecoder().decode([String].self, from: savedData) {
            self.startDevModeApps = decoded
        } else {
            self.startDevModeApps = []
        }
        
        if let availableData = UserDefaults.standard.data(forKey: "availableAppsData"),
           let availableDecoded = try? JSONDecoder().decode([String].self, from: availableData) {
            self.availableApps = availableDecoded
        } else {
            self.availableApps = []
        }
    }

    func addCustomApp() {
        if !newAppName.isEmpty && !availableApps.contains(newAppName) {
            availableApps.append(newAppName)
        }
    }

    func toggleApp(_ app: String) {
        if startDevModeApps.contains(app) {
            startDevModeApps.removeAll { $0 == app }
        } else {
            startDevModeApps.append(app)
        }
        // The array will be saved to UserDefaults automatically due to the didSet observer
    }

    func openFilePicker() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["app"]

        if panel.runModal() == .OK, let url = panel.url {
            let appName = url.lastPathComponent.replacingOccurrences(of: ".app", with: "")
            if !availableApps.contains(appName) {
                availableApps.append(appName)
                // Saving happens automatically due to the didSet observer
            }
        }
    }
}
