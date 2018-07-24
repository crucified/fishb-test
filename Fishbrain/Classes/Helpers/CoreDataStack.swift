//
//  CoreDataStack.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//

import Foundation
import CoreData

class CoreDataStack {
    static var shared = CoreDataStack()

    private var _context: NSManagedObjectContext? = nil
    private var _model: NSManagedObjectModel? = nil
    private var _coordinator: NSPersistentStoreCoordinator? = nil
    private init() { }

    lazy var context: NSManagedObjectContext = {
        guard _context == nil else { return _context! }

        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        _context = context
        return context
    }()

    lazy var model: NSManagedObjectModel = {
        guard _model == nil else { return _model! }

        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("could not read model")
        }
        _model = model
        return model

    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard _coordinator == nil else { return _coordinator! }

        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("could not get documents directory URL")
        }

        let storageURL: URL
        #if DEBUG
        storageURL = url.appendingPathComponent("FishBrainStorage-TEST.sqlite")
        #else
        storageURL = url.appendingPathComponent("FishBrainStorage.sqlite")
        #endif

        let persCoord = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        do {
            try persCoord.addPersistentStore(ofType: NSSQLiteStoreType,
                                             configurationName: nil,
                                             at: storageURL,
                                             options: nil)
        } catch {
            fatalError("could not add store: \(error)")
        }
        _coordinator = persCoord
        return persCoord;
    }()
}
