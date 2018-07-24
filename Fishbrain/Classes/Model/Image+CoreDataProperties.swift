//
//  Image+CoreDataProperties.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var height: Float
    @NSManaged public var urlString: String?
    @NSManaged public var width: Float

}
