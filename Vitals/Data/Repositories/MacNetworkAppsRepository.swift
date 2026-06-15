//
//  MacNetworkAppsRepository.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

final class MacNetworkAppsRepository: NetworkAppsRepository {
    func getActiveNetworkApps() -> [NetworkAppEntity] {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "nettop -P -L 1 -J bytes_in,bytes_out | awk -F',' 'NR>1 {print $1 \",\" $2 \",\" $3}'"]
        
        do {
            try task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8) else { return [] }
            
            var apps: [NetworkAppEntity] = []
            let lines = output.components(separatedBy: .newlines).filter { !$0.isEmpty }
            
            for line in lines {
                let parts = line.components(separatedBy: ",")
                if parts.count >= 3 {
                    let cleanName = String(parts[0].split(separator: ".").first ?? "")
                    let bytesIn = Double(parts[1]) ?? 0
                    let bytesOut = Double(parts[2]) ?? 0
                    
                    if bytesIn > 100_000 || bytesOut > 100_000 {
                        apps.append(NetworkAppEntity(name: cleanName, bytesIn: bytesIn, bytesOut: bytesOut))
                    }
                }
            }
            
            var grouped: [String: (in: Double, out: Double)] = [:]
            for app in apps {
                let current = grouped[app.name] ?? (0, 0)
                grouped[app.name] = (current.in + app.bytesIn, current.out + app.bytesOut)
            }
            
            let result = grouped.map { NetworkAppEntity(name: $0.key, bytesIn: $0.value.in, bytesOut: $0.value.out) }
            return result.sorted { ($0.bytesIn + $0.bytesOut) > ($1.bytesIn + $1.bytesOut) }
        }catch {
            return []
        }
    }
}
