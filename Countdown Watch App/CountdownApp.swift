//
//  CountdownApp.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 20/12/2022.
//

import SwiftUI
import WatchKit

@main
struct Countdown_Watch_AppApp: App {
    @StateObject var timerModel: TimerModel = .init()
    
    // MARK: Scene phase
    @Environment(\.scenePhase) var phase
    
    // MARK: Storing last time stamp
    @State var lastActiveTimeStamp: Date = Date()
    
    // 1. Clic home button: inactive - back (stop running)
    // 2. lock the screen: inactive for a while - back (stop running)
    // 3. Clic multi-task button: inactive (keeping running)
    // 4. From home back to app: inactive (start running) - active
    @State var enterBackModel = 0 // 0: Not enter back yet. 1: already enter back before
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background{
                    enterBackModel = 1
                    lastActiveTimeStamp = Date()
                    print("back")
                }
                if newValue == .active && timerModel.totalSeconds != 0 {
                    print("active")
                    // Finding the difference
                    checkingTime()
                    
                }
                if newValue == .inactive{
                    print("inactive")
                    lastActiveTimeStamp = Date()
                    
                }
                
            }
        }
          
    }
    
    func checkingTime(){
        
        let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
        print(currentTimeStampDiff)
        if timerModel.totalSeconds  - Int(currentTimeStampDiff) <= 0 {
            timerModel.timerSound = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                WKInterfaceDevice.current().play(.success)
            })
            timerModel.isFinished = true
            timerModel.stopTimer()
            // terporary solusion: if the diff > 13s, then it means the user lock the screen
            // Because inactive will be called either lock the screen or open multi-task. however, we should not change the time when it's multi-task
        } else if enterBackModel == 1 || currentTimeStampDiff >= 10{
            
            enterBackModel = 0
            withAnimation(.default) {
                timerModel.totalSeconds -= Int(currentTimeStampDiff)
            }
            
        }
    }
    

}
