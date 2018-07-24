//
//  Bait+CoreDataProperties.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//
//

import Foundation
import CoreData


extension Bait {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bait> {
        return NSFetchRequest<Bait>(entityName: "Bait")
    }

    @NSManaged public var id: Int64
    @NSManaged public var localizedName: String?
    @NSManaged public var name: String?
    @NSManaged public var image: NSSet?

}

// MARK: Generated accessors for image
extension Bait {

    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: Image)

    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: Image)

    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)

    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)

}
