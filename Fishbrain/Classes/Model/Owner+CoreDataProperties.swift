//
//  Owner+CoreDataProperties.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//
//

import Foundation
import CoreData


extension Owner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Owner> {
        return NSFetchRequest<Owner>(entityName: "Owner")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var nickName: String?
    @NSManaged public var avatar: NSSet?

}

// MARK: Generated accessors for avatar
extension Owner {

    @objc(addAvatarObject:)
    @NSManaged public func addToAvatar(_ value: Image)

    @objc(removeAvatarObject:)
    @NSManaged public func removeFromAvatar(_ value: Image)

    @objc(addAvatar:)
    @NSManaged public func addToAvatar(_ values: NSSet)

    @objc(removeAvatar:)
    @NSManaged public func removeFromAvatar(_ values: NSSet)

}
