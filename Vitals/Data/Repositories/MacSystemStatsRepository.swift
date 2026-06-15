//
//  MacSystemStatsRepository.swift
//  Vitals
//
//  Created by Sajudin on 13/06/26.
//

import Foundation

final class MacSystemStatsRepository: SystemStatsRepository {
    private var previousCpuInfo: processor_info_array_t?
    private var numCpuInfo: mach_msg_type_number_t = 0
    private var cpuInfoLock = NSLock()
    
    func getSystemUsage() throws -> SystemUsage {
        let cpuLoad = getCpuLoad()
        let ramData = getRAMUsage()
        let swapUsed = getSwapUsage()
        let thermalState = getThermalState()
        let pressure = getMemoryPressure(stats: ramData.rawStats, totalRAM: ramData.total)
        
        return SystemUsage(
            cpuLoad: cpuLoad,
            totalRAM: ramData.total,
            usedRAM: ramData.used,
            appMemory: ramData.appMem,
            wiredMemory: ramData.wiredMem,
            compressedMemory: ramData.compressedMem,
            cachedFiles: ramData.cachedMem,
            swapUsed: swapUsed,
            thermalState: thermalState,
            memoryPressure: pressure
        )
    }
    
    private func getCpuLoad() -> Double {
        var numCPUsU: natural_t = 0
        var cpuInfo: processor_info_array_t?
        var numCpuInfoU: mach_msg_type_number_t = 0
        
        var numCPUs: Int = 0
        var len: Int = MemoryLayout<Int>.size
        var mibKeys: [Int32] = [ CTL_HW, HW_NCPU ]
        sysctl(&mibKeys, 2, &numCPUs, &len, nil, 0)
        numCPUsU = natural_t(numCPUs)
        
        let result = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfoU)
        
        guard result == KERN_SUCCESS, let cpuInfo = cpuInfo else { return 0.0 }
        
        cpuInfoLock.lock()
        defer {cpuInfoLock.unlock()}
        
        var totalInUse: Double = 0
        var totalAll: Double = 0
        
        if let prevInfo = previousCpuInfo {
            for i in 0..<Int(numCPUsU) {
                let inUse = Double(
                    (cpuInfo[Int(CPU_STATE_MAX) * i + Int(CPU_STATE_USER)]   - prevInfo[Int(CPU_STATE_MAX) * i +
                                                                                        Int(CPU_STATE_USER)])
                    + (cpuInfo[Int(CPU_STATE_MAX) * i + Int(CPU_STATE_SYSTEM)] - prevInfo[Int(CPU_STATE_MAX) * i +
                                                                                          Int(CPU_STATE_SYSTEM)])
                    + (cpuInfo[Int(CPU_STATE_MAX) * i + Int(CPU_STATE_NICE)]   - prevInfo[Int(CPU_STATE_MAX) * i +
                                                                                          Int(CPU_STATE_NICE)])
                )
                
                let total = inUse + Double(
                    cpuInfo[Int(CPU_STATE_MAX) * i + Int(CPU_STATE_IDLE)] - prevInfo[Int(CPU_STATE_MAX) * i + Int(CPU_STATE_IDLE)]
                )
                
                totalInUse += inUse
                totalAll += total
            }
            
            let prevInfoSize = vm_size_t(MemoryLayout<integer_t>.size * Int(self.numCpuInfo))
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: prevInfo), prevInfoSize)
        }
        
        self.previousCpuInfo = cpuInfo
        self.numCpuInfo = numCpuInfoU
        
        return totalAll > 0 ? (totalInUse / totalAll) * 100.0 : 0.0
    }
    
    private func getRAMUsage() -> (used: Double, total: Double, appMem: Double, wiredMem: Double, compressedMem: Double, cachedMem:
                                    Double, rawStats: vm_statistics64) {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        var usedBytes: UInt64 = 0
        var appBytes: UInt64 = 0
        var wiredBytes: UInt64 = 0
        var compBytes: UInt64 = 0
        var cachedBytes: UInt64 = 0
        
        if result == KERN_SUCCESS {
            let active = UInt64(stats.active_count)
            let wired = UInt64(stats.wire_count)
            let compressed = UInt64(stats.compressor_page_count)
            let inactive = UInt64(stats.inactive_count)
            
            let pageSize = UInt64(getpagesize())
            
            appBytes = active * pageSize
            wiredBytes = wired * pageSize
            compBytes = compressed * pageSize
            cachedBytes = inactive * pageSize
            
            usedBytes = appBytes + wiredBytes + compBytes
        }
        
        let totalBytes = ProcessInfo.processInfo.physicalMemory
        let gbDivisor = 1_073_741_824.0
        
        return (
            used: Double(usedBytes) / gbDivisor,
            total: Double(totalBytes) / gbDivisor,
            appMem: Double(appBytes) / gbDivisor,
            wiredMem: Double(wiredBytes) / gbDivisor,
            compressedMem: Double(compBytes) / gbDivisor,
            cachedMem: Double(cachedBytes) / gbDivisor,
            rawStats: stats
        )
    }
    
    private func getSwapUsage() -> Double{
        var xswUsage  = xsw_usage()
        var size = MemoryLayout<xsw_usage>.size
        let mib = [CTL_VM, VM_SWAPUSAGE]
        if sysctl(UnsafeMutablePointer(mutating: mib), 2, &xswUsage, &size, nil, 0) == 0 {
            return Double(xswUsage.xsu_used) / 1_073_741_824.0
        }
        
        return 0.0
    }
    
    private func getThermalState() -> String {
        switch ProcessInfo.processInfo.thermalState {
        case .nominal: return "Normal"
        case .fair: return "Fair (Hangat)"
        case .serious: return "Serious (Panas)"
        case .critical: return "Critical (Overheat)"
        @unknown default: return "Unknown"
        }
    }
    
    private func getMemoryPressure(stats: vm_statistics64, totalRAM: Double) -> MemoryPressureLevel {
        let pageSize = Double(getpagesize())
        let totalPages = totalRAM * 1_073_741_824.0 / pageSize
        
        let compressedRatio = Double(stats.compressor_page_count) / totalPages
        
        let swappedRatio = Double(stats.pageouts) / max(totalPages, 1)
        
        if compressedRatio > 0.15 || swappedRatio > 0.05 {
            return .critical
        } else if compressedRatio > 0.07 {
            return .warning
        } else {
            return .normal
        }
    }
}
