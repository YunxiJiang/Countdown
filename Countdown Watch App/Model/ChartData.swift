//
//  ChartData.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 27/12/2022.
//

import Foundation

struct ChartData: Identifiable {
    let id = UUID()
    let date: Date // x
    let time: Int // y

}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
