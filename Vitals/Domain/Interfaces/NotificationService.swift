//
//  NotificationService.swift
//  Vitals
//
//  Created by Sajudin on 15/06/26.
//

import Foundation

protocol NotificationService {
    func requestAuthorization()
    func sendNotification(identifier: String, title: String, body: String)
}
