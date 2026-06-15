//
//  EnergyAppsRepository.swift
//  Vitals
//

import Foundation

protocol EnergyAppsRepository: Sendable {
    nonisolated func getTopEnergyApps(limit: Int) -> [EnergyAppEntity]
}

final class MacEnergyAppsRepository: EnergyAppsRepository, Sendable {
    
    nonisolated func getTopEnergyApps(limit: Int) -> [EnergyAppEntity] {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.launchPath = "/bin/bash"
        // Run top with 2 samples, 1 second interval, order by power, and show pid, command, power
        task.arguments = ["-c", "top -l 2 -s 1 -n \(limit) -stats pid,command,power -o power | tail -n \(limit + 1)"]
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8) else {
                return []
            }
            
            var apps: [EnergyAppEntity] = []
            let lines = output.components(separatedBy: .newlines)
            
            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty || trimmed.contains("PID") || trimmed.contains("COMMAND") {
                    continue
                }
                
                // Example format: "29652  agy              15.3"
                let components = trimmed.split(separator: " ", omittingEmptySubsequences: true)
                guard components.count >= 3 else { continue }
                
                let pidStr = String(components[0])
                let powerStr = String(components.last!)
                
                // Command might have spaces, so join everything in between
                let commandComponents = components.dropFirst().dropLast()
                let commandName = commandComponents.joined(separator: " ")
                
                if let pid = Int(pidStr), let power = Double(powerStr) {
                    if power > 0.0 { // Only show apps that are actually using energy
                        apps.append(EnergyAppEntity(pid: pid, name: commandName, power: power))
                    }
                }
            }
            
            return apps
            
        } catch {
            return []
        }
    }
}
