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
