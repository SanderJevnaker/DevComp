import SwiftUI

struct VPNConfigView: View {
    @State private var host: String = UserDefaults.standard.string(forKey: "VPNHost") ?? ""
    @State private var port: String = UserDefaults.standard.string(forKey: "VPNPort") ?? ""
    @State private var username: String = UserDefaults.standard.string(forKey: "VPNUsername") ?? ""
    @State private var password: String = UserDefaults.standard.string(forKey: "VPNPassword") ?? ""
    @State private var cert: String = UserDefaults.standard.string(forKey: "VPNCert") ?? ""
    @State private var isSaved = false
    
    var body: some View {
        Form {
            Section(header: Text("VPN Details")) {
                TextField("Host", text: $host)
                TextField("Port", text: $port)
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                TextField("Cert", text: $cert)
            }
            
            Button("Save Configuration") {
                UserDefaults.standard.setValue(host, forKey: "VPNHost")
                UserDefaults.standard.setValue(port, forKey: "VPNPort")
                UserDefaults.standard.setValue(username, forKey: "VPNUsername")
                UserDefaults.standard.setValue(password, forKey: "VPNPassword")
                UserDefaults.standard.setValue(cert, forKey: "VPNCert")
                isSaved = true
                print("Saved Configuration")
            }
        }
        .padding()
        .alert(isPresented: $isSaved) {
            Alert(title: Text("Saved"), message: Text("VPN Configuration has been saved."), dismissButton: .default(Text("OK")))
        }
    }
}
