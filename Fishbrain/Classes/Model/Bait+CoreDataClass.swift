//
//  Bait+CoreDataClass.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//
//

import Foundation
import CoreData

@objc(Bait)
public class Bait: NSManagedObject, Codable, ImagesParseable {

    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("No NSManagedObjectContext provided in decoder.userInfo for key .context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Bait.self), in: context) else {
            fatalError("Could not create entity for \(String(describing: Bait.self))")
        }

        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: Keys.self)
        self.id = try container.decode(ID.self, forKey: .id)
        self.localizedName = try? container.decode(String.self, forKey: .localizedName)
        self.name = try? container.decode(String.self, forKey: .name)
        self.addToImage(images(from: container, forKey: .image))
    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    private enum Keys: CodingKey {
        case id
        case image
        case localizedName
        case name
    }
}

extension Bait: PropertiesIteratable {
    var properties: [String] {
        return ["name", "localizedName", "image"]
    }
}
