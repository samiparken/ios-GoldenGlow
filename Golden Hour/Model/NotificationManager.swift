import Foundation
import UserNotifications

class NotificationManager {

    let center = UNUserNotificationCenter.current()
    
    func askPermission() {
        center.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, error) in })
    }
    
    func setNotification(_ body: String, _ date: Date) {
        let content = UNMutableNotificationContent()
        content.body = body
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute,.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print(error as Any)
        }
    }
    
}
