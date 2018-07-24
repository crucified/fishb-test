//
//  Species+CoreDataClass.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//
//

import Foundation
import CoreData

@objc(Species)
public class Species: NSManagedObject, Decodable, ImagesParseable  {


    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("No NSManagedObjectContext provided in decoder.userInfo for key .context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Species.self), in: context) else {
            fatalError("Could not create entity for \(String(describing: Species.self))")
        }

        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: Keys.self)

        self.id = try container.decode(ID.self, forKey: .id)
        self.name = try? container.decode(String.self, forKey: .name)
        self.species = try? container.decode(String.self, forKey: .species)
        self.addToPhoto(images(from: container, forKey: .photo))
    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }


    private enum Keys: String, CodingKey {
        case id
        case image
        case name
        case photo
        case species
    }
}

extension Species: PropertiesIteratable {
    var properties: [String] {
        return ["name", "species", "image", "photo"]
    }
}
