//
//  MacDiskIORepository.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

final class MacDiskIORepository: DiskIORepository, @unchecked Sendable {
    nonisolated(unsafe) private var previousRead: UInt64 = 0
    nonisolated(unsafe) private var previousWrite: UInt64 = 0
    nonisolated(unsafe) private var previousTime: Date = Date()
    private let lock = NSLock()
    
    nonisolated func getDiskIO() -> DiskIOStats {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.launchPath = "/usr/sbin/ioreg"
        task.arguments = ["-c", "IOBlockStorageDriver", "-k", "Statistics", "-r"]
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8) else {
                return DiskIOStats(readSpeedBytes: 0, writeSpeedBytes: 0, totalReadBytes: 0, totalWriteBytes: 0)
            }
            
            var currentRead: UInt64 = 0
            var currentWrite: UInt64 = 0
            
            let lines = output.components(separatedBy: .newlines)
            for line in lines {
                if line.contains("Bytes (Read)") {
                    currentRead += extractValue(from: line, key: "Bytes (Read)")
                }
                if line.contains("Bytes (Write)") {
                    currentWrite += extractValue(from: line, key: "Bytes (Write)")
                }
            }
            
            // Kunci akses variabel lintas-thread
            lock.lock()
            defer { lock.unlock() }
            
            let now = Date()
            let timeElapsed = now.timeIntervalSince(previousTime)
            
            var readSpeed: UInt64 = 0
            var writeSpeed: UInt64 = 0
            
            if previousRead > 0 && previousWrite > 0 && timeElapsed > 0 {
                if currentRead >= previousRead {
                    readSpeed = UInt64(Double(currentRead - previousRead) / timeElapsed)
                }
                if currentWrite >= previousWrite {
                    writeSpeed = UInt64(Double(currentWrite - previousWrite) / timeElapsed)
                }
            }
            
            previousRead = currentRead
            previousWrite = currentWrite
            previousTime = now
            
            return DiskIOStats(
                readSpeedBytes: readSpeed,
                writeSpeedBytes: writeSpeed,
                totalReadBytes: currentRead,
                totalWriteBytes: currentWrite
            )
            
        } catch {
            return DiskIOStats(readSpeedBytes: 0, writeSpeedBytes: 0, totalReadBytes: 0, totalWriteBytes: 0)
        }
    }
    
    nonisolated private func extractValue(from line: String, key: String) -> UInt64 {
        if let range = line.range(of: "\"\(key)\"=") {
            let substring = line[range.upperBound...]
            let numberString = substring.prefix(while: { $0.isNumber })
            return UInt64(numberString) ?? 0
        }
        return 0
    }
}
