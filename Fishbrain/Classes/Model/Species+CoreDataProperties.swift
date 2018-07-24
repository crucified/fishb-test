//
//  Species+CoreDataProperties.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//
//

import Foundation
import CoreData


extension Species {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Species> {
        return NSFetchRequest<Species>(entityName: "Species")
    }

    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var species: String?
    @NSManaged public var photo: NSSet?

}

// MARK: Generated accessors for photo
extension Species {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Image)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Image)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}
