//
//  Storage.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 15.07.2018.
//

import Foundation
import CoreData

protocol StorageProtocol {

    func save(catches: [Catch])
    func upsert(aCatch: Catch)
    func aCatch(forID: ID) -> Catch?
}


class Storage: StorageProtocol {

    static let shared = Storage()

    private let coreData = CoreDataStack.shared

    /// Saves cathes overwriting existing record with the same id
    ///
    /// - Parameter catches: catches to save
    func save(catches: [Catch]) {
        for it in catches {
            upsert(aCatch: it, needSaveContext: false)
        }
    }

    /// Updates or inserts a catch
    ///
    /// - Parameter aCatch: cath to insert
    func upsert(aCatch: Catch) {
        upsert(aCatch: aCatch, needSaveContext: true)
    }

    private func upsert(aCatch: Catch, needSaveContext: Bool) {
        if let existingCatch = self.aCatch(forID: aCatch.id) {
            ObjectsUpdater.update(existingCatch, with: aCatch)
        } else {
            insert(aCatch: aCatch)
        }
    }

    /// Fetch single catch from database by catch id
    ///
    /// - Parameter id: ID of the catch
    /// - Returns: catch or nil of nothing found
    func aCatch(forID id: ID) -> Catch? {
        let request = fetchRequest(forCatchID: id)
        do {
            let catches = try coreData.context.fetch(request)
            assert(catches.count <= 1, "many catches with the same ID are not acceptable")
            return catches.first
        } catch {
            print("\(#function) error: \(error)")
            return nil
        }
    }

    private func fetchRequest(forCatchID id: ID) -> NSFetchRequest<Catch> {

        let fetchRequest = NSFetchRequest<Catch>(entityName: String(describing: Catch.self))
        let predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}

// Mark: - Insertions
private extension Storage {
    func insert(aCatch: Catch) {
        insert(aCatch.owner)
        insert(aCatch.bait)
        insert(aCatch.species)
        insert(aCatch.method)
        if let photos = aCatch.photos as? Set<Image> {
            for it in photos {
                insert(it)
            }
        }
        insert(aCatch)

    }

    func insert<T: NSManagedObject>(_ obj: T?) {
        if let obj = obj {
            coreData.context.insert(obj)
        }
    }
}
