//
//  Owner+CoreDataClass.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//
//

import Foundation
import CoreData

@objc(Owner)
public class Owner: NSManagedObject, Codable, ImagesParseable {

    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("No NSManagedObjectContext provided in decoder.userInfo for key .context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Owner.self), in: context) else {
            fatalError("Could not create entity for \(String(describing: Owner.self))")
        }

        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: Keys.self)
        self.id = try container.decode(ID.self, forKey: .id)
        self.firstName = try? container.decode(String.self, forKey: .firstName)
        self.lastName = try? container.decode(String.self, forKey: .lastName)
        self.nickName = try? container.decode(String.self, forKey: .nickname)
        self.addToAvatar(images(from: container, forKey: .avatar))
    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    private enum Keys: String, CodingKey {
        case id
        case avatar
        case firstName
        case lastName
        case nickname
    }
}

extension Owner: PropertiesIteratable {
    var properties: [String] {
        return ["firstName", "lastName", "nickName", "avatar"]
    }
}
