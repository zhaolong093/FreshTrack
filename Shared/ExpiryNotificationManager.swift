//
//  ExpiryNotificationManager.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//

import Foundation
import UserNotifications

final class ExpiryNotificationManager {

    static let shared = ExpiryNotificationManager()
    static let categoryIdentifier = "FRESHTRACK_EXPIRY"

    private init() { }

    // MARK: Permission

    func requestPermission() async {
        
        registerNotificationCategory()

        do {

            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [
                            .alert,
                            .sound,
                            .badge
                ])

            print( "Notification permission: \(granted)")

        } catch {

            print( "Notification permission error: \(error)")
        }
    }
    
    // MARK: - Category

        private func registerNotificationCategory() {

            let category = UNNotificationCategory(
                identifier: Self.categoryIdentifier,
                actions: [],
                intentIdentifiers: [],
                options: []
            )

            UNUserNotificationCenter
                .current()
                .setNotificationCategories([category])
        }


    // MARK: Test Notification

    func scheduleTestNotification() {

        let content = UNMutableNotificationContent()

        content.title = "FreshTrack"
        content.body = "Milk expires tomorrow."
        content.sound = .default
        content.categoryIdentifier = Self.categoryIdentifier

        // Data used by the custom extension
        content.userInfo = [
            "foodName": "Milk",
            "expiryMessage": "Expires tomorrow",
            "storageLocation": "Fridge",
            "quantity": 1
        ]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest( identifier: "freshtrack-test-notification", content: content,
                trigger: trigger
            )

        UNUserNotificationCenter
            .current()
            .add(request) { error in

                if let error {

                    print("❌ Notification scheduling failed: \(error)")

                } else {

                    print("✅ FreshTrack notification scheduled")
                }
            }
    }
    
    // MARK: - Real Expiry Notification

    func scheduleExpiryNotification( for foodItem: FoodItem) {

        let calendar = Calendar.current

        let expiryDay = calendar.startOfDay(for: foodItem.expiryDate)

        guard let dayBeforeExpiry = calendar.date(
                byAdding: .day,
                value: -1,
                to: expiryDay
            )
        else {
            return
        }

        var reminderComponents = calendar.dateComponents([.year, .month, .day], from: dayBeforeExpiry
            )

        // Notify at 9:00 AM
        reminderComponents.hour = 9
        reminderComponents.minute = 0

        let reminderDate = calendar.date(from: reminderComponents)

        let content = UNMutableNotificationContent()

        content.title = "Use it before you lose it"

        content.body = "\(foodItem.name) is approaching its expiry date."

        content.sound = .default

        content.categoryIdentifier = Self.categoryIdentifier

        content.userInfo = ["foodName":foodItem.name,

            "expiryMessage": expiryMessage(for: foodItem),

            "storageLocation":foodItem.storageLocation.name,

            "quantity":foodItem.quantity]

        let identifier = notificationIdentifier( for: foodItem.id)

        let center = UNUserNotificationCenter.current()

        // Remove old reminder if this food was edited/re-added.
        center.removePendingNotificationRequests( withIdentifiers: [identifier])

        if let reminderDate,reminderDate > Date() {

            let triggerComponents = calendar.dateComponents(
                    [
                        .year,
                        .month,
                        .day,
                        .hour,
                        .minute
                    ],
                    from: reminderDate
                )

            let trigger = UNCalendarNotificationTrigger( dateMatching: triggerComponents, repeats: false)

            let request = UNNotificationRequest(
                    identifier: identifier,
                    content: content,
                    trigger: trigger
                )
            center.add(request)

        } else {

            // Food is already within the reminder window.
            // Deliver shortly after it is added.
            let trigger =
                UNTimeIntervalNotificationTrigger(
                    timeInterval: 10,
                    repeats: false
                )

            let request = UNNotificationRequest(
                    identifier: identifier,
                    content: content,
                    trigger: trigger
                )

            center.add(request)
        }
    }

    func cancelExpiryNotification( for foodID: UUID) {

        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(
                withIdentifiers: [
                    notificationIdentifier(
                        for: foodID
                    )
                ]
            )
    }

    // MARK: Helpers

    private func notificationIdentifier(for foodID: UUID) -> String {
        "freshtrack-expiry-\(foodID.uuidString)"
    }

    private func expiryMessage(for foodItem: FoodItem
    ) -> String {
        let calendar = Calendar.current

        let today = calendar.startOfDay( for: Date())

        let expiry = calendar.startOfDay( for: foodItem.expiryDate)

        let days = calendar.dateComponents([.day],
                from: today,
                to: expiry
            ).day ?? 0

        switch days {

        case ..<0:
            return "Expired"

        case 0:
            return "Expires today"

        case 1:
            return "Expires tomorrow"

        default:
            return "Expires in \(days) days"
        }
    }
}
