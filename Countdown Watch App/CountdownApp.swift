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
    
    @StateObject var timeDataController = TimeDataController()
    
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
    
    @State var isLockAndBackToBackground = false
    
    
    @State var isUpdateInInactive = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
                .environment(\.managedObjectContext, timeDataController.container.viewContext)
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background{
                    
                    enterBackModel = true
                    timerModel.backTime = Date()
                    
                    if Int(timerModel.backTime.timeIntervalSince(timerModel.inactiveTimeFirst)) > 119 {
                        isLockAndBackToBackground = true
                    } else {
                        isLockAndBackToBackground = false
                    }
                    
                }
                if newValue == .active && timerModel.totalSeconds != 0 {
                    
                    let curentTime = Date()
                    let timeInterl = curentTime.timeIntervalSince(timerModel.startTime)
                    if timerModel.staticTotalSeconds - Int(timeInterl) <= 0 {
                        timerModel.isFinished = true
                        timerModel.stopTimer()
                    } else if enterBackModel == false && isUpdateInInactive == false && Int(Date().timeIntervalSince(inactiveCounts == 1 ? timerModel.inactiveTimeFirst : timerModel.inactiveTimeSecond)) > 4{ // lock, not into back
                        
                        updateTime(time: timerModel.inactiveTimeFirst)
                        enterBackModel = false
                        isUpdateInInactive = false
                        inactiveCounts = 0
                        
                    } else { // Multi-task
                        
                        isUpdateInInactive = false
                        inactiveCounts = 0
                    }

                    
                }
                if newValue == .inactive{
                    
                    inactiveCounts += 1
                    
                    
                    if inactiveCounts == 1 {
                        timerModel.inactiveTimeFirst = Date()
                        
                    } else {
                        timerModel.inactiveTimeSecond = Date()
                    }
                    
                    
                    if enterBackModel == true && isLockAndBackToBackground  { //  lock - into background
                        
                        updateTime(time: timerModel.inactiveTimeFirst)
                        enterBackModel = false
                        isUpdateInInactive = true
                        inactiveCounts = 0
                    } else if enterBackModel == true && inactiveCounts >= 2 { // app - home - app
                        
                        updateTime(time: timerModel.backTime)
                        enterBackModel = false
                        isUpdateInInactive = true
                        inactiveCounts = 0
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    func updateTime(time: Date){
        withAnimation(.spring()) {
            let currentTimeStampDiff = Date().timeIntervalSince(time)
            timerModel.totalSeconds -= Int(currentTimeStampDiff)
        }
        if timerModel.totalSeconds <= 0 {
            timerModel.isFinished = true
            timerModel.stopTimer()
        }
        
        
    }

    
    
}
