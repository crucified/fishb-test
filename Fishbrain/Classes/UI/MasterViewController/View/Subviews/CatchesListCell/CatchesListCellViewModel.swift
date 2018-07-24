//
//  CatchesListCellViewModel.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 23.07.2018.
//

import Foundation


struct CatchesListCellViewModel {
    let id: ID
    let speciesName: String
    let ownerName: String
    let photos: [Image]


    init?(model: Catch) {
        guard let speciesName = model.species?.name else {
            return nil
        }

        var photos = [Image]()
        if let userPhotos = model.photos?.allObjects as? [Image],
            userPhotos.count > 0 {

            photos = userPhotos
        } else if let speciesPhotos = model.species?.photo?.allObjects as? [Image] {
            photos = speciesPhotos
        }

        self.id = model.id
        self.speciesName = speciesName
        self.photos = photos

        var availableNames = [String]()
        if let firstName = model.owner?.firstName {
            availableNames.append(firstName)
        }

        if let nickName = model.owner?.nickName {
            availableNames.append(nickName)
        }

        if let lastName = model.owner?.lastName {
            availableNames.append(lastName)
        }

        if availableNames.isEmpty {
            self.ownerName = .defaultOwnerName
        } else {
            self.ownerName = availableNames.joined(separator: " ")
        }

    }
}

private extension String {
    static var defaultOwnerName: String { return "Nameless Gloryhunter" }
}
