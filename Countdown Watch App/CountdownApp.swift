//
//  CountdownApp.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 20/12/2022.
//

import SwiftUI
import WatchKit
import UserNotifications

@main
struct Countdown_Watch_AppApp: App {
    @StateObject var timerModel: TimerModel = .init()
    
    @State var inactiveCounts: Int = 0
    
    // MARK: Scene phase
    @Environment(\.scenePhase) var phase
    
    // MARK: Storing last time stamp
    @State var lastActiveTimeStamp: Date = Date()
    
    // 1. Clic home button: inactive - back (stop running)
    // 2. lock the screen: inactive for a while - back (stop running)
    // 3. Clic multi-task button: inactive (keeping running)
    // 4. From home back to app: inactive (start running) - active
    @State var enterBackModel = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background{
                    enterBackModel = true
                    timerModel.backTime = Date()
                    
                    
                    // Alarm notification
                    // lock screen, back to background
                    let timeInterval = Int(timerModel.backTime.timeIntervalSince(timerModel.inactiveTime))
                    if timeInterval >= 100 && enterBackModel == true{
                        
                        let timerIntervalForNotification = timerModel.staticTotalSeconds - Int(timerModel.inactiveTime.timeIntervalSince(timerModel.startTime))
                        
                        
                        timerModel.Notification(timerInterval: timerIntervalForNotification)
                        
                    } else if enterBackModel == true && inactiveCounts == 1 { // app -> home
                        let timerIntervalForNotification = timerModel.staticTotalSeconds - Int(timerModel.backTime.timeIntervalSince(timerModel.startTime))
                        
                        
                        timerModel.Notification(timerInterval: timerIntervalForNotification)
                    }
                    
                }
                if newValue == .active && timerModel.totalSeconds != 0 {
                    
                    
                    // update time
                    // lock screen, not back to background
                    if inactiveCounts == 1 && enterBackModel == false && Int(Date().timeIntervalSince(timerModel.inactiveTime)) != 0{
                        updateTime(time: timerModel.inactiveTime)
                        enterBackModel = false
                        inactiveCounts = 0
                    }
                    
                    
                }
                if newValue == .inactive{
                    
                    timerModel.inactiveTime = Date()
                    
                    inactiveCounts += 1
                    // Alarm notification
                    // lockscreen, not back to background, don't alarm notification for now, just update view. Because eventually, the app will back to background or even the user is watching the view, when time is up, it will also sent notification
                    //                    if inactiveCounts == 1 && enterBackModel == false && Int(Date().timeIntervalSince(timerModel.inactiveTime)) != 0 {
                    //                    }
                    
                    // update time
                    // home -> app
                    if inactiveCounts == 2 && enterBackModel == true {
                        updateTime(time: timerModel.backTime)
                        enterBackModel = false
                        inactiveCounts = 0
                    }
                    
                    
                }
                
            }
        }
        
    }
    
    func updateTime(time: Date){
        withAnimation(.default) {
            let currentTimeStampDiff = Date().timeIntervalSince(time)
            timerModel.totalSeconds -= Int(currentTimeStampDiff)
        }
        if timerModel.totalSeconds <= 0 {
            //                timerModel.timerSound = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            //                    WKInterfaceDevice.current().play(.success)
            //                })
            timerModel.isFinished = true
            timerModel.stopTimer()
        }
        
        
    }
    
    //    func checkingTime(){
    //
    //        let currentTimeStampDiff = Date().timeIntervalSince(timerModel.backTime)
    //
    //        if timerModel.totalSeconds  - Int(currentTimeStampDiff) <= 0 {
    //            timerModel.timerSound = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
    //                WKInterfaceDevice.current().play(.success)
    //            })
    //            timerModel.isFinished = true
    //            timerModel.stopTimer()
    //
    //        } else if enterBackModel == true{
    //
    //            enterBackModel = false
    //            withAnimation(.default) {
    //
    //            }
    //
    //        }
    //    }
    
    
}
