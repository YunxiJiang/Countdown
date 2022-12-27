//
//  ChartView.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 27/12/2022.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    // Use for store data
    @Environment(\.managedObjectContext) var moc
    
    //    @FetchRequest(sortDescriptors: []) var timeData: FetchedResults<Time>
    
    let data: [ChartData] = [
        .init(date: Date.from(year: 2023, month: 1, day: 22), DataElement: 25),
        .init(date: Date.from(year: 2023, month: 1, day: 23), DataElement: 50),
        .init(date: Date.from(year: 2023, month: 1, day: 24), DataElement: 70),
        .init(date: Date.from(year: 2023, month: 1, day: 25), DataElement: 30),
        .init(date: Date.from(year: 2023, month: 1, day: 26), DataElement: 30),
        .init(date: Date.from(year: 2023, month: 1, day: 27), DataElement: 5),
        .init(date: Date.from(year: 2023, month: 1, day: 28), DataElement: 5),
        .init(date: Date.from(year: 2023, month: 1, day: 29), DataElement: 5),
        .init(date: Date.from(year: 2023, month: 1, day: 30), DataElement: 5),
        .init(date: Date.from(year: 2023, month: 1, day: 31), DataElement: 6),
        .init(date: Date.from(year: 2023, month: 2, day: 1), DataElement: 8),
        .init(date: Date.from(year: 2023, month: 2, day: 2), DataElement: 10),
        .init(date: Date.from(year: 2023, month: 2, day: 3), DataElement: 70),
        .init(date: Date.from(year: 2023, month: 2, day: 4), DataElement: 20)
    ]
    
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
        if (highlightedDateIndex - chartDataRange.lowerBound) < 2, chartDataRange.lowerBound > 0 {
            let newLowerBound = max(0, chartDataRange.lowerBound - 1)
            let newUpperBound = min(newLowerBound + 6, data.count - 1)
            chartDataRange = (newLowerBound...newUpperBound)
            return
        }
        if (chartDataRange.upperBound - highlightedDateIndex) < 2, chartDataRange.upperBound < data.count - 1 {
            let newUpperBound = min(chartDataRange.upperBound + 1, data.count - 1)
            let newLowerBound = max(0, newUpperBound - 6)
            chartDataRange = (newLowerBound...newUpperBound)
            return
        }
    }
    
    private var chartData: [ChartData] {
        Array(data[chartDataRange.clamped(to: (0...data.count - 1))]).sorted{
            $0.date < $1.date
        }
    }
    
    private func isLastDataPoint(_ dataPoint: ChartData) -> Bool {
        data[chartDataRange.upperBound].id == dataPoint.id
    }
    
    private var chart: some View {
        Chart(chartData) { dataPoint in
            BarMark(x: .value("Date", dataPoint.date, unit: .day),
                    y: .value("Completed", dataPoint.DataElement))
            .foregroundStyle(Color.green.opacity(0.6).gradient)
            .annotation(
                position: isLastDataPoint(dataPoint) ? .topLeading : .topTrailing,
                spacing: 0
            ){}
            
            RuleMark(x: .value("Date", crownOffsetDate, unit: .day))
                .foregroundStyle(Color.orange.opacity(crownPositionOpacity).gradient)
        }
        .chartXAxis {
            AxisMarks(format: shortDateFormatStyle)
        }
    }
    
    /// The date value that corresponds to the crown offset.
    private var crownOffsetDate: Date {
        let dateDistance = data[0].date.distance(
            to: data[data.count - 1].date) * (crownOffset / Double(data.count - 1))
        return data[0].date.addingTimeInterval(dateDistance)
    }
    
    var body: some View {
        chart
            .focusable()
            .digitalCrownRotation(
                detent: $highlightedDateIndex,
                from: 0,
                through: data.count - 1,
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
                    crownPositionOpacity = newValue ? 0.2 : 1.0
                }
            }
            .onChange(of: highlightedDateIndex) { newValue in
                withAnimation {
                    updateChartDataRange()
                }
            }
            .padding()
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Time Spend")
            .navigationBarTitleDisplayMode(.inline)
    }
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
        
    }
}
