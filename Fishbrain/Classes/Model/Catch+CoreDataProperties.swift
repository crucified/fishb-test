//
//  Catch+CoreDataProperties.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//
//

import Foundation
import CoreData


extension Catch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catch> {
        return NSFetchRequest<Catch>(entityName: "Catch")
    }

    @NSManaged public var caughtAtGMT: NSDate?
    @NSManaged public var caughtAtLocalTimeZone: NSDate?
    @NSManaged public var deepLink: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var externalID: String?
    @NSManaged public var id: Int64
    @NSManaged public var length: Float
    @NSManaged public var privateFishingWater: Bool
    @NSManaged public var privatePosition: Bool
    @NSManaged public var staffPicked: Bool
    @NSManaged public var weatherCondition: String?
    @NSManaged public var weight: Float
    @NSManaged public var windDirection: String?
    @NSManaged public var bait: Bait?
    @NSManaged public var method: Method?
    @NSManaged public var owner: Owner?
    @NSManaged public var photos: NSSet?
    @NSManaged public var species: Species?

}

// MARK: Generated accessors for photos
extension Catch {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Image)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Image)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
