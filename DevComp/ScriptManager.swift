import Foundation

class ScriptManager {
    
    @objc func killSpringboot() {
        let script = """
        #!/bin/bash
        count=0
        ps aux | grep java | grep -v grep | grep spring-boot-starter | while read -r line
        do
          echo "Debug: $line"
          pid=$(echo $line | awk '{print $2}')
          if [ $pid != $$ ]; then  # Skip the current script's process
            echo "Killing process with PID $pid..."
            kill -15 $pid
            count=$((count + 1))
          fi
        done
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
