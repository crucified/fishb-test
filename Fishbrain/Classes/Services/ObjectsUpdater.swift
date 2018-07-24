//
//  ObjectsUpdater.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//

import Foundation
import CoreData


/// protocol `PropertiesIteratable` is required to perform KVC over the object
/// for swift 4.2 this protocol can be replaced with @dynamicMemberLookup
protocol PropertiesIteratable where Self: NSObject {
    /// list of the properties to be able to be used by KVC
    var properties: [String] { get }
}


/// Class `ObjectsUpdater` updates two objects of the same type by skipping nil values from newObject.
final class ObjectsUpdater {
    typealias PropertiesIterableObject = NSObject & PropertiesIteratable
    private init() { }

    /// Update old object with values from new object.
    /// !!!No id checks!!!
    /// Supposed that properties of old and new are the same and KVC compliant
    ///
    /// - Parameters:
    ///   - old: old object
    ///   - new: new object
    /// This class uses KVC under the hood, which can lead to runtime errors unless keys are incorrect
    static func update(_ old: PropertiesIterableObject, with new: PropertiesIterableObject) {
        guard type(of: old) == type(of: new) else { return }

        let properties = old.properties

        guard properties == new.properties else { return }

        for p in properties {
            guard let value = new.value(forKey: p) else { continue }

            if value is PropertiesIterableObject {
                if let oldValue = old.value(forKey: p) as? PropertiesIterableObject {
                    ObjectsUpdater.update(oldValue, with: value as! PropertiesIterableObject)
                }
            } else if let newSequence = value as? NSSet {
                if let oldSequence = old.value(forKey: p) as? NSSet,
                    newSequence.count > oldSequence.count {

                    let mutableSet = old.mutableSetValue(forKey: p)
                    mutableSet.removeAllObjects()
                    mutableSet.addObjects(from: newSequence.allObjects)

                }
            } else {
                old.setValue(value, forKey: p)
            }
        }

    }
}
