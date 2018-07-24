//
//  DetailViewModel.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 24.07.2018.
//

import Foundation


struct DetailViewModel {

    let bait: DetailViewModelItem?
    let species: DetailViewModelItem?
    let description: DetailViewModelItem?
    let method: DetailViewModelItem?
    let weather: DetailViewModelItem?
    let wind: DetailViewModelItem?

    private let detailsInOrder: [DetailViewModelItem]

    init(catchItem: Catch) {
        var order = [DetailViewModelItem]()

        var description: DetailViewModelItem?
        if let descriptionText = catchItem.descriptionText,
            descriptionText.isEmpty == false {

            description = DetailViewModelItem(title: "Description", subtitle: descriptionText, imageURL: nil)
            order.append(description!)
        }

        var species: DetailViewModelItem?
        if let catchSpecies = catchItem.species {
            species = DetailViewModelItem(title: "Species", subtitle: catchSpecies.name ?? "-",
                                          imageURL: (catchSpecies.photo?.allObjects as? [Image])?.largest())
            order.append(species!)
        }

        var method: DetailViewModelItem?
        if let catchMethod = catchItem.method {
            method = DetailViewModelItem(title: "Method", subtitle: catchMethod.localizedName ?? "-",
                                         imageURL: (catchMethod.coverImage?.allObjects as? [Image])?.largest())
            order.append(method!)
        }

        var bait: DetailViewModelItem?
        if let catchBait = catchItem.bait {
            bait = DetailViewModelItem(title: "Bait", subtitle: catchBait.localizedName ?? "-",
                                       imageURL: (catchBait.image?.allObjects as? [Image])?.largest())
            order.append(bait!)
        }

        var weather: DetailViewModelItem?
        if let catchWeather = catchItem.weatherCondition,
            catchWeather.isEmpty == false {

            weather = DetailViewModelItem(title: "Weather", subtitle: catchWeather, imageURL: nil)
            order.append(weather!)
        }

        var wind: DetailViewModelItem?
        if let catchWind = catchItem.weatherCondition,
            catchWind.isEmpty == false {

            wind = DetailViewModelItem(title: "Wind", subtitle: catchWind, imageURL: nil)
            order.append(wind!)
        }

        self.description = description
        self.species = species
        self.method = method
        self.bait = bait
        self.weather = weather
        self.wind = wind
        self.detailsInOrder = order
    }

    func itemsCount() -> Int {
        return detailsInOrder.count
    }

    func detailItem(atIndex index: Int) -> DetailViewModelItem {
        return detailsInOrder[index]
    }

}

struct DetailViewModelItem {
    let title: String
    let subtitle: String
    let imageURL: URL?
}
