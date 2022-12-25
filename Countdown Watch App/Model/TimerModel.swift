//
//  TimerModel.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 20/12/2022.
//

import SwiftUI
import UserNotifications


class TimerModel: NSObject,UNUserNotificationCenterDelegate, ObservableObject {
    
    
    
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var selectPickerIndex = 0
    
    // Total Seconds
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    // isFinished whole countdown
    @Published var isFinished: Bool = false
    
    // Timer sound
    @Published var timerSound: Timer? = nil
    
    // Measure what time the app start countdown
    @Published var startTime: Date = Date()
    // Measure what time when the app go to the background
    @Published var backTime: Date = Date()
    // Measure what time when the app is on inactive
    @Published var inactiveTime: Date = Date()
    
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    func startTimer(){
        startTime = Date()
        isStarted = true
        isFinished = false
        // Setting String value
        timerStringValue = "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        // Caculating total seconds for timer bar animation
        totalSeconds = minutes * 60 + seconds
        staticTotalSeconds = totalSeconds
    }
    
    func stopTimer(){
        isStarted = false
        
        withAnimation {
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
       
    }
    
    func updateTimer(){
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        if minutes == 0 && seconds == 0 {
//            timerSound = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//                WKInterfaceDevice.current().play(.success)
//            })
            Notification(timerInterval: 1)
            isFinished = true
            stopTimer()
        }

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Telling what to do when receivies in foreground
        completionHandler([.banner, .sound])
    }
    
    func authorizeNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge]) { _, _ in
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func Notification(timerInterval: Int){
         
        let content = UNMutableNotificationContent()
        content.title = "Countdown"
        content.body = "The Time is Up"
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 10)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerInterval), repeats: false)
        
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req) { (error) in
            if error != nil {
                print("error in notification \(String(describing: error))")
            }

        }

    }
    
    
    
}
