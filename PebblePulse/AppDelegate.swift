//
//  AppDelegate.swift
//  PebblePulse
//
//  Created by Hrishikesh Vikram on 11/12/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var db: Firestore! // Declare Firestore instance



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           // Initialize Firebase
           FirebaseApp.configure()
            UNUserNotificationCenter.current().delegate = self

           // Request notification permissions and schedule notifications
           self.setupNotifications(application)
           
           return true
       }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // Modify this based on how you want the notification to present.
    }

    private func setupNotifications(_ application: UIApplication) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            // Request permission to display alerts and play sounds.
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Error requesting notification authorization: \(error)")
                }
            }
            
            // Define the actions for the notification
            let rateAction1 = UNNotificationAction(identifier: "rate1", title: "1", options: [])
            let rateAction2 = UNNotificationAction(identifier: "rate2", title: "2", options: [])
            let rateAction3 = UNNotificationAction(identifier: "rate3", title: "3", options: [])
            let rateAction4 = UNNotificationAction(identifier: "rate4", title: "4", options: [])
            
            let category = UNNotificationCategory(identifier: "MOOD_RATE",
                                                  actions: [rateAction1, rateAction2, rateAction3, rateAction4],
                                                  intentIdentifiers: [],
                                                  options: [])
            
            center.setNotificationCategories([category])
            
            // Schedule a notification to ask the user to rate their mood every 20 seconds
            let content = UNMutableNotificationContent()
            content.title = "Rate Your Mood"
            content.body = "How are you feeling right now?"
            content.categoryIdentifier = "MOOD_RATE"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
        

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotificationResponse(response)
        completionHandler()
    }
    
    private func handleNotificationResponse(_ response: UNNotificationResponse) {
        // Identify which action was taken by the user and handle it accordingly
        let actionIdentifier = response.actionIdentifier
        let moodValue = Int(actionIdentifier.replacingOccurrences(of: "rate", with: "")) ?? 0
        let cost = Int.random(in: 1...100) // Generate a random cost
        
        // Assume we have a current user ID and a method to save the transaction
        if let userId = Auth.auth().currentUser?.uid {
            saveMoodTransaction(userId: userId, mood: moodValue, cost: cost)
        }
    }
    private func saveMoodTransaction(userId: String, mood: Int, cost: Int) {
        // No need for the class-level Firestore instance
        let db = Firestore.firestore()
        let transactionData: [String: Any] = [
            "mood": mood,
            "cost": cost,
            "timeHappened": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(userId).collection("transactions").addDocument(data: transactionData) { error in
            if let error = error {
                print("Error saving transaction: \(error.localizedDescription)")
            } else {
                print("Transaction saved successfully")
            }
        }
    }

    
}

