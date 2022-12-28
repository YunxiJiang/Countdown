//
//  ChartView.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 27/12/2022.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    
    @StateObject var timeDataController = TimeDataController()
    
//    @FetchRequest(sortDescriptors: []) var data: FetchedResults<TimeData>
    
//    let data: [ChartData] = [
//        .init(date: Date.from(year: 2023, month: 1, day: 22), time: 25),
//        .init(date: Date.from(year: 2023, month: 1, day: 24), time: 50),
//        .init(date: Date.from(year: 2023, month: 1, day: 23), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 25), time: 30),
//        .init(date: Date.from(year: 2023, month: 1, day: 26), time: 30),
//        .init(date: Date.from(year: 2023, month: 1, day: 27), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 28), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 29), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 30), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 31), time: 6),
//        .init(date: Date.from(year: 2023, month: 2, day: 1), time: 8),
//        .init(date: Date.from(year: 2023, month: 2, day: 2), time: 10),
//        .init(date: Date.from(year: 2023, month: 2, day: 3), time: 70),
//        .init(date: Date.from(year: 2023, month: 2, day: 4), time: 20)
//    ]
    
    /// The index of the highlighted chart value. This is for crown scrolling.
    @State private var highlightedDateIndex: Int = 0
    
    /// The current offset of the crown while it's rotating. This sample sets the offset with
    /// the value in the DigitalCrownEvent and uses it to show an intermediate
    /// (between detents) chart value in the view.
    @State private var crownOffset: Double = 0.0
    
    @State private var isCrownIdle = true
    
    @State var crownPositionOpacity: CGFloat = 0.2
    
    @State var chartDataRange = (0...6)
    
    private var shortDateFormatStyle = DateFormatStyle(dateFormatTemplate: "Md")
    
    private func updateChartDataRange() {
//        var chartDataRange = (0...(timeDataController.data.count < 6 ? timeDataController.data.count : 6))
        
        if (highlightedDateIndex - chartDataRange.lowerBound) < 2, chartDataRange.lowerBound > 0 {
            let newLowerBound = max(0, chartDataRange.lowerBound - 1)
            let newUpperBound = min(newLowerBound + 6, timeDataController.data.count - 1)
            chartDataRange = (newLowerBound...newUpperBound)
            return
        }
        if (chartDataRange.upperBound - highlightedDateIndex) < 2, chartDataRange.upperBound < timeDataController.data.count - 1 {
            let newUpperBound = min(chartDataRange.upperBound + 1, timeDataController.data.count - 1)
            let newLowerBound = max(0, newUpperBound - 6)
            chartDataRange = (newLowerBound...newUpperBound)
            return
        }
    }
    
    private var chartData: [TimeData] {
        Array(timeDataController.data[chartDataRange.clamped(to: (0...timeDataController.data.count - 1))])
    }
    
//    private var data = timeDataController.data
    
    private func isLastDataPoint(_ dataPoint: TimeData) -> Bool {
        if chartDataRange.upperBound < timeDataController.data.count {
            return timeDataController.data[chartDataRange.upperBound].id == dataPoint.id
        } else {
            return timeDataController.data[timeDataController.data.count - 1].id == dataPoint.id
        }
        
    }
    
    private var chart: some View {
        Chart(chartData) { dataPoint in
            BarMark(x: .value("Date", dataPoint.date!, unit: .day),
                    y: .value("Completed", dataPoint.minutes))
            .foregroundStyle(Color.green.opacity(0.6).gradient)
//            .annotation(
//                position: isLastDataPoint(dataPoint) ? .topLeading : .topTrailing,
//                spacing: 0
//            ){}
            
            RuleMark(x: .value("Date", crownOffsetDate, unit: .day))
                .foregroundStyle(Color.orange.opacity(crownPositionOpacity).gradient)
        }
        .chartXAxis {
            AxisMarks(format: shortDateFormatStyle)
        }
    }
    
    /// The date value that corresponds to the crown offset.
    private var crownOffsetDate: Date {
        
        let dateDistance = timeDataController.data[0].date!.distance(
            to: timeDataController.data[timeDataController.data.count - 1].date!) * (crownOffset / Double(timeDataController.data.count - 1))
        return timeDataController.data[0].date!.addingTimeInterval(dateDistance)
    }
    
    var body: some View {
        
        if timeDataController.data.isEmpty || timeDataController.data.count <= 1 {
            VStack(alignment: .leading, spacing: 10){
                Text("Need to have more time spend data")
                    .fontWeight(.bold)
                Text("Please keep using app")
                    .fontWeight(.bold)
            }
            .navigationTitle("Time Spend")
            .navigationBarTitleDisplayMode(.inline)

        } else {
            chart
                .focusable()
                .digitalCrownRotation(
                    detent: $highlightedDateIndex,
                    from: 0,
                    through: timeDataController.data.count - 1,
                    by: 1,
                    sensitivity: .medium
                ) { crownEvent in
                    isCrownIdle = false
                    crownOffset = crownEvent.offset
                } onIdle: {
                    isCrownIdle = true
                }
                .onChange(of: isCrownIdle) { newValue in
                    withAnimation(newValue ? .easeOut : .easeIn) {
                        crownPositionOpacity = newValue ? 0.5 : 1.0
                    }
                }
                .onChange(of: highlightedDateIndex) { newValue in
                    withAnimation(.easeInOut) {
                        updateChartDataRange()
                    }
                }
    //            .edgesIgnoringSafeArea(.bottom)
                .padding()
                .navigationTitle("Time Spend")
                .navigationBarTitleDisplayMode(.inline)
        }
        


    }
        
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
        
    }
}
