//
//  Method+CoreDataClass.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//
//

import Foundation
import CoreData

@objc(Method)
public class Method: NSManagedObject, Codable, ImagesParseable {

    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("No NSManagedObjectContext provided in decoder.userInfo for key .context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Method.self), in: context) else {
            fatalError("Could not create entity for \(String(describing: Method.self))")
        }

        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: Keys.self)

        self.id = try container.decode(ID.self, forKey: .id)
        self.localizedName = try? container.decode(String.self, forKey: .localizedName)
        self.addToCoverImage(images(from: container, forKey: .coverImage))
    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    private enum Keys: String, CodingKey {
        case id
        case localizedName
        case coverImage
    }

}

extension Method: PropertiesIteratable {
    var properties: [String] {
        return ["localizedName", "coverImage"]
    }
}

