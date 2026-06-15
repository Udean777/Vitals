//
//  MacTopProcessesRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

final class MacTopProcessesRepository: TopProcessesRepository {
    func getTopProcess(limit: Int) throws -> [ProcessEntity] {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.launchPath = "/bin/bash"
        
        task.arguments = ["-c", "ps -arcxo pid,pcpu,rss,comm | head -n \(limit + 1)"]
        
        try task.run()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else {
            return []
        }
        
        var processes: [ProcessEntity] = []
        let lines = output.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        for i in 1..<lines.count {
            let line = lines[i]
            
            let components = line.trimmingCharacters(in: .whitespaces).components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
            
            if components.count >= 4 ,
               let pid = Int(components[0]),
               let cpu = Double(components[1]),
               let mem = Double(components[2]) {
                
                let name = components[3...].joined(separator: " ")
                processes.append(ProcessEntity(pid: pid, name: name, cpuUsage: cpu, ramUsage: mem))
            }
        }
        
        return processes
    }
    
    func killProcess(pid: Int) throws {
        let result = kill(pid_t(pid), SIGTERM)
        if result != 0 {
            throw NSError(domain: "VitalsError", code: Int(result), userInfo: [NSLocalizedDescriptionKey: "Gagal menghentikan proses \(pid)."])
        }
    }
}
