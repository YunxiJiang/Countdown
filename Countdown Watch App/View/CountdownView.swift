//
//  CountdownView.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 27/12/2022.
//

import SwiftUI
import UserNotifications

struct CountdownView: View {
    @EnvironmentObject var timerModel: TimerModel
    
    @StateObject var timeDataController = TimeDataController()
    // Countdown time
    @State var stepperIndex: Double = 25.0
    
    var body: some View {
        VStack {
            
            GeometryReader { proxy in
                
                // MARK: Timer Ring
                ZStack{
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.02))
                            .padding(-30)
                        
                        // MARK: Shadow
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color.green,lineWidth: 5)
                            .blur(radius: 7)
                            .padding(-2)
                            .animation(.easeInOut, value: timerModel.progress)
                        
                        Circle()
                            .fill(Color.black.opacity(0.15))
                        
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color.green.opacity(0.6), lineWidth: 15)
                            .animation(.easeInOut, value: timerModel.progress)
                    }
                    
                    // Time number
                    if (timerModel.isStarted) {
                        Text(timerModel.timerStringValue)
                            .font(.system(size: 45, weight: .bold))
                            .rotationEffect(.init(degrees: 90))
                        
                    } else {
                        Stepper(value: $stepperIndex, in: (5.0...50.0), step: 5.0, format: .number) {}
                            .foregroundColor(.white)
                            .accentColor(.clear)
                            .rotationEffect(.init(degrees: 90))
                            .padding(10)
                        
                    }
                    
                }
                .frame(height: proxy.size.width)
                .rotationEffect(.init(degrees: -90))
                .onTapGesture {
                    if timerModel.isStarted == false {
                        WKInterfaceDevice.current().play(.start)
                        timerModel.minutes = Int(stepperIndex)
                        timerModel.isStarted = true
                        timerModel.startTimer()
                    } else{
                        WKInterfaceDevice.current().play(.directionDown)
                        timerModel.stopTimer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
//            Button {
//                var day = 1
//                var time = 10
//                var count = 20
//                while count > 0 {
//                    let date = Date.from(year: 2022, month: 1, day: day)
//                    timeDataController.addTimeData(date: date, time: time)
//                    day += 1
//                    time += 5
//                    count -= 1
//                }
//            } label: {
//                Text("Add data")
//            }
//
//            Button {
//                timeDataController.deleteAll()
//            } label: {
//                Text("delete data")
//            }

        }
        .padding()
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if timerModel.isStarted {
                timerModel.updateTimer()
            }
        }
        .alert(isPresented: $timerModel.isFinished) {
            Alert(title: Text("\(Int(stepperIndex)) minutes is up"), message: nil, dismissButton: .cancel(Text("Close")){
                timerModel.timerSound?.invalidate()
                timerModel.timerSound = nil
                timerModel.stopTimer()
            })
        }
        .onAppear {
            // Permissions for nitification
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
            }
            
            // Setting Delagete Fro In - App Notification
            UNUserNotificationCenter.current().delegate = timerModel
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .environmentObject(TimerModel())
    }
}