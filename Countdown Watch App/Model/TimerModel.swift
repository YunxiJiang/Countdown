//
//  TimerModel.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 20/12/2022.
//

import SwiftUI
import UserNotifications

class TimerModel: NSObject,UNUserNotificationCenterDelegate, ObservableObject {
    
    @StateObject var timeDataController = TimeDataController()
    
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
    @Published var inactiveTimeFirst: Date = Date()
    
    @Published var inactiveTimeSecond: Date = Date()
    
//    @Published var minutesForDataSets: Int32 = 0
    
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
print(minutes)
        Notification(timerInterval: staticTotalSeconds)
    }
    
//    func updateOrAddTime(index: Int?, currentDate: Date, minutes: Int32) {
//        if index == nil {
//            timeDataController.addTimeData(date: currentDate, minutes: minutes)
//        } else {
//            let newMinutes = timeDataController.data[index!].minutes + minutes
//            timeDataController.updateTimeData(index: index!, newMinutes: newMinutes)
//        }
//    }
    
    func stopTimer(){
//        let currentDate = Date()
        if totalSeconds <= 0 { // Complete whole countdown
            print("test stop: static \(staticTotalSeconds)")
            let minutes = Int32(staticTotalSeconds / 60)
            timeDataController.addTimeData(date: startTime, minutes: minutes)
            print("test: Complete whole countdown add \(minutes) mins")
            
        } else {
            let minutes = Int32((staticTotalSeconds - totalSeconds) / 60)
            timeDataController.addTimeData(date: startTime, minutes: minutes)
            print("test: Not complete add \(minutes) mins")
        }
        
        isStarted = false
        
        withAnimation {
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        

       
    }
    
    func updateTime(){
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        if totalSeconds <= 0 {
//            timerSound = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//                WKInterfaceDevice.current().play(.success)
//            })
            isFinished = true
            stopTimer() // add minutes to database
        }

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Telling what to do when receivies in foreground
        
//        stopTimer()
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
