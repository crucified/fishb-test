//
//  Method+CoreDataProperties.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//
//

import Foundation
import CoreData


extension Method {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Method> {
        return NSFetchRequest<Method>(entityName: "Method")
    }

    @NSManaged public var id: Int64
    @NSManaged public var localizedName: String?
    @NSManaged public var coverImage: NSSet?

}

// MARK: Generated accessors for coverImage
extension Method {

    @objc(addCoverImageObject:)
    @NSManaged public func addToCoverImage(_ value: Image)

    @objc(removeCoverImageObject:)
    @NSManaged public func removeFromCoverImage(_ value: Image)

    @objc(addCoverImage:)
    @NSManaged public func addToCoverImage(_ values: NSSet)

    @objc(removeCoverImage:)
    @NSManaged public func removeFromCoverImage(_ values: NSSet)

}
