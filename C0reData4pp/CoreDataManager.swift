//
//  CoreDataManager.swift
//  C0reData4pp
//
//  Created by sergey.tereshkin on 12/01/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "companiesModel")
        
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
}
