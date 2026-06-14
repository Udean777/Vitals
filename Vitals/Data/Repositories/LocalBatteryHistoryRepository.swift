//
//  LocalBatteryHistoryRepository.swift
//  Vitals
//
//  Created by Sajudin on 14/06/26.
//

import Foundation

final class LocalBatteryHistoryRepository {
    private let storageKey = "vitals_battery_history_v1"
    
    func getHistory() -> [BatteryHistoryPoint] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let history = try? JSONDecoder().decode([BatteryHistoryPoint].self, from: data) else {
            return []
        }
        return history
    }
    
    func addPoint(percentage: Double) {
        var history = getHistory()
        
        if let last = history.last, Date().timeIntervalSince(last.timestamp) < 300 {
            return
        }
        
        let newPoint = BatteryHistoryPoint(timestamp: Date(), percentage: percentage)
        history.append(newPoint)
        
        let twentyFourHoursAgo = Date().addingTimeInterval(-86400)
        history = history.filter { $0.timestamp > twentyFourHoursAgo }
        
        save(history)
    }
    
    func generateMockDataIfNeeded() {
        var history = getHistory()
        
        if history.isEmpty {
            let now = Date()
            var simulatedLevel = 100.0
            for i in (0..<24).reversed() {
                let time = now.addingTimeInterval(TimeInterval(-i * 3600))
                simulatedLevel -= Double.random(in: 2...8)
                if simulatedLevel <= 20 { simulatedLevel = 100 }
                
                history.append(BatteryHistoryPoint(timestamp: time, percentage: simulatedLevel))
            }
            save(history)
        }
    }
    
    private func save(_ history: [BatteryHistoryPoint]) {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
