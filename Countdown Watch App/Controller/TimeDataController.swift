//
//  TimeDataController.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 27/12/2022.
//

import Foundation
import CoreData

class TimeDataController: ObservableObject {
    
    let container: NSPersistentContainer
    
    // Store add time data
//    @Published var newTimeData: [TimeData] = []
    
//    let data1: [ChartData] = [
//        .init(date: Date.from(year: 2023, month: 1, day: 22), time: 25),
//        .init(date: Date.from(year: 2023, month: 1, day: 22), time: 50),
//        .init(date: Date.from(year: 2023, month: 1, day: 25), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 25), time: 30),
//        .init(date: Date.from(year: 2023, month: 1, day: 26), time: 30),
//        .init(date: Date.from(year: 2023, month: 1, day: 26), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 26), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 29), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 30), time: 5),
//        .init(date: Date.from(year: 2023, month: 1, day: 31), time: 6),
//        .init(date: Date.from(year: 2023, month: 2, day: 1), time: 8),
//        .init(date: Date.from(year: 2023, month: 2, day: 2), time: 10),
//        .init(date: Date.from(year: 2023, month: 2, day: 3), time: 70),
//        .init(date: Date.from(year: 2023, month: 2, day: 4), time: 20)
//    ]
    
    @Published var data: [TimeData] = []
    
    init() {
        container = NSPersistentContainer(name: "Time")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading core data. \(error)")
            }
        }
        
        fetchTimeData()
    }
    
    func fetchTimeData(){
        let request = NSFetchRequest<TimeData>(entityName: "TimeData")
        
        do {
            data = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
        
    }
    
    func deleteAll(){
        for entity in data {
            container.viewContext.delete(entity)
        }
        saveTimeData()
    }
    
    func addTimeData(date: Date, minutes: Int32){
        let newTime = TimeData(context: container.viewContext)
        newTime.id = UUID()
        newTime.date = date
        newTime.minutes = minutes
        
        saveTimeData()
    }
    
    private func saveTimeData(){
        do {
            try container.viewContext.save()
            fetchTimeData()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}
