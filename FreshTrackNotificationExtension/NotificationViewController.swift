//
//  NotificationViewController.swift
//  FreshTrackNotificationExtension
//
//  Created by 是她 on 7/10/2026.
// FRESHTRACK_EXPIRY

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        label.numberOfLines = 0
        label.textAlignment = .left
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let content = notification.request.content
        
        let foodName = content.userInfo["foodName"] as? String ?? "Food Item"
        let expiryMessage = content.userInfo["expiryMessage"] as? String ?? "Expiring soon"
        let storageLocation = content.userInfo["storageLocation"] as? String ?? "Unknown location"

        let quantity = content.userInfo["quantity"] as? Int ?? 1
        
        label.text =
                """
                ⚠️ Use it before you lose it

                \(foodName)

                \(expiryMessage)
                Stored in: \(storageLocation)
                Quantity: \(quantity)
                """

    }

}
