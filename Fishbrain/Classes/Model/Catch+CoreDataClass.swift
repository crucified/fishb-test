//
//  Catch+CoreDataClass.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//
//

import Foundation
import CoreData

@objc(Catch)
public class Catch: NSManagedObject, Decodable, ImagesParseable {

    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("No NSManagedObjectContext provided in decoder.userInfo for key .context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Catch.self), in: context) else {
            fatalError("Could not create entity for \(String(describing: Catch.self))")
        }

        super.init(entity: entity, insertInto: nil)
        let container = try decoder.container(keyedBy: Keys.self)

        self.id = try container.decode(ID.self, forKey: .id)
        self.length = (try? container.decode(Float.self, forKey: .length)) ?? 0.0
        self.weight = (try? container.decode(Float.self, forKey: .weight)) ?? 0.0
        self.deepLink = try? container.decode(String.self, forKey: .deepLink)
        self.descriptionText = try? container.decode(String.self, forKey: .descriptionText)
        self.externalID = try? container.decode(String.self, forKey: .externalId)
        self.privateFishingWater = (try? container.decode(Bool.self, forKey: .privateFishingWater)) ?? false
        self.privatePosition = (try? container.decode(Bool.self, forKey: .privatePosition)) ?? false
        self.staffPicked = (try? container.decode(Bool.self, forKey: .staffPicked)) ?? false

        if let weatherContainer = try? container.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weatherCondition) {

            weatherCondition = try? weatherContainer.decode(String.self, forKey: .localizedName)
        }

        if let windContainer = try? container.nestedContainer(keyedBy: WeatherKeys.self, forKey: .windDirection) {
            self.windDirection = try windContainer.decode(String.self, forKey: .localizedName)
        }

        if let stringValue = try? container.decode(String.self, forKey: .caughtAtGmt),
            let caughtGMTDate = DateFormatterFactory.shared
                .formatter(for: Constants.gmtDateFormat)
                .date(from: stringValue) {
            self.caughtAtGMT = caughtGMTDate as NSDate
        }

        if let stringValue = try? container.decode(String.self, forKey: .caughtAtLocalTimeZone),
            let caughtAtLocalDate = DateFormatterFactory.shared
                .formatter(for: Constants.loclaDateFormat)
                .date(from: stringValue) {
            self.caughtAtLocalTimeZone = caughtAtLocalDate as NSDate
        }

        self.bait = try? container.decode(Bait.self, forKey: .bait)
        self.owner = try? container.decode(Owner.self, forKey: .owner)
        self.method = try? container.decode(Method.self, forKey: .method)
        self.species = try? container.decode(Species.self, forKey: .species)
        if var photosArrayContainer = try? container.nestedUnkeyedContainer(forKey: .photos),
            let photosContainer = try? photosArrayContainer.nestedContainer(keyedBy: PhotosKeys.self) {

            self.addToPhotos(images(from: photosContainer, forKey: .photo))
        }

    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }


    private enum Keys: String, CodingKey {
        case deepLink
        case descriptionText = "description"
        case caughtAtGmt
        case caughtAtLocalTimeZone
        case externalId
        case id
        case length
        case photos
        case privateFishingWater
        case privatePosition
        case staffPicked
        case weatherCondition
        case weight
        case windDirection
        case bait
        case method
        case owner
        case species
    }

}

extension Catch: PropertiesIteratable {
    var properties: [String] {
        return ["deepLink", "descriptionText", "caughtAtGMT", "caughtAtLocalTimeZone", "externalID",
                "length", "photos", "privateFishingWater", "privatePosition", "staffPicked",
                "weatherCondition", "weight", "windDirection", "bait", "method", "owner", "species"]
    }
}

private enum WeatherKeys: String, CodingKey {
    case id
    case type
    case localizedName
}

private enum PhotosKeys: String, CodingKey {
    case type
    case id
    case photo
}

private enum Constants {
    static let gmtDateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let loclaDateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSXXX"
}

