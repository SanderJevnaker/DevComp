import SwiftUI
import CommonCrypto

struct SelectableText: NSViewRepresentable {
    var text: String

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.isEditable = false
        textField.isSelectable = true
        textField.isBordered = false
        textField.backgroundColor = nil
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
}

struct Base64View: View {
    @State private var text = ""
    @State private var result = ""

    var body: some View {
        VStack {
            Text("Encode / Decode")
                .font(.headline)
            TextField("Enter text here", text: $text)
            HStack {
                Button("Base64") {
                    self.result = Data(self.text.utf8).base64EncodedString()
                }
                Button("MD5") {
                    self.result = md5(self.text)
                }
                Button("SHA1") {
                    self.result = sha1(self.text)
                }
                Button("ROT13") {
                    self.result = rot13(self.text)
                }
            }
            HStack {
                Button("Base64 Decode") {
                    if let data = Data(base64Encoded: self.text) {
                        self.result = String(data: data, encoding: .utf8) ?? "Invalid Base64 String"
                    } else {
                        self.result = "Invalid Base64 String"
                    }
                }
                Button("ROT13 Decode") {
                    self.result = rot13(self.text)
                }
            }
            if !result.isEmpty {
                SelectableText(text: "Result: \(result)")
            }
        }
        .padding()
    }

    func md5(_ string: String) -> String {
        let data = Data(string.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    func sha1(_ string: String) -> String {
        let data = Data(string.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    func rot13(_ string: String) -> String {
        return string.unicodeScalars.map {
            var code = $0.value
            switch $0.value {
            case 65...90:
                code = ((code - 65 + 13) % 26) + 65
            case 97...122:
                code = ((code - 97 + 13) % 26) + 97
            default: break
            }
            return String(UnicodeScalar(code)!)
        }.joined()
    }
}






