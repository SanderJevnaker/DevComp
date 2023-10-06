import SwiftUI
import Cocoa
import Foundation

struct PreferencesView: View {
    @ObservedObject var viewModel = PreferencesViewModel()

    var body: some View {
        VStack {
            Text("Preferences")
            ForEach(viewModel.availableApps, id: \.self) { appName in
                Toggle("Start \(appName)", isOn: Binding<Bool>(
                    get: { self.viewModel.startDevModeApps.contains(appName) },
                    set: { newValue in
                        if newValue {
                            self.viewModel.toggleApp(appName)
                        } else {
                            self.viewModel.startDevModeApps.removeAll { $0 == appName }
                        }
                    }
                ))
            }
            HStack {
                Button("Add application") {
                    viewModel.openFilePicker()
                }
            }
        }
        .padding()
    }
}
