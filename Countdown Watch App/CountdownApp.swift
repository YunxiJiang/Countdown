//
//  CountdownApp.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 20/12/2022.
//

import SwiftUI

@main
struct Countdown_Watch_AppApp: App {
    @StateObject var timerModel: TimerModel = .init()
    
    // MARK: Scene phase
    @Environment(\.scenePhase) var phase
    
    // MARK: Storing last time stamp
    @State var lastActiveTimeStamp: Date = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }

    }
}
