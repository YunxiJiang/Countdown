//
//  ContentView.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 20/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var timerModel: TimerModel
    
    @State var stepperIndex: Double = 25.0
    
    var body: some View {
        VStack {
            
            GeometryReader { proxy in
                
                // MARK: Timer Ring
                ZStack{
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-30)
                        
                        // MARK: Shadow
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color.green,lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                            .animation(.easeInOut, value: timerModel.progress)
                        
                        Circle()
                            .fill(Color.black)
                        
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color.green.opacity(0.7), lineWidth: 13)
                            .animation(.easeInOut, value: timerModel.progress)
                    }
                    
                    // Time number
                    if (timerModel.isStarted) {
                        Text(timerModel.timerStringValue)
                            .font(.system(size: 45, weight: .bold))
                            .rotationEffect(.init(degrees: 90))

                    } else {
                        Stepper(value: $stepperIndex, in: (5.0...50.0), step: 5.0, format: .number) {
                            
                        }
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
                        timerModel.minutes = Int(stepperIndex)
                        timerModel.isStarted = true
                        timerModel.startTimer()
                    } else{
                        timerModel.stopTimer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            
        }
        .padding()
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if timerModel.isStarted {
                timerModel.updateTimer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerModel())
    }
}
