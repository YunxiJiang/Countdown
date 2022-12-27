//
//  TimeDataController.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 27/12/2022.
//

import Foundation
import CoreData

class TimeDataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Time")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
