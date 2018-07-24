//
//  Image+CoreDataClass.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject, Codable {

    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("No NSManagedObjectContext provided in decoder.userInfo for key .context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Image.self), in: context) else {
            fatalError("Could not create entity for \(String(describing: Image.self))")
        }

        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: Keys.self)

        self.width = try container.decode(Float.self, forKey: .width)
        self.height = try container.decode(Float.self, forKey: .height)
        self.urlString = try container.decode(String.self, forKey: .url)

    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    private enum Keys: CodingKey {
        case width
        case height
        case url
    }
}
