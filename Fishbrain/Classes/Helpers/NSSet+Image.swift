//
//  ImageURLSelector.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 23.07.2018.
//

import Foundation
import CoreGraphics

/// A tiny helper extension which will help to select url by required size
extension Array where Element: Image {
    func best(toFitWidth width: Float) -> URL? {
        var bestURL: URL?
        var bestDelta = Float.greatestFiniteMagnitude
        for e: Image in self {
            let newDelta = abs(width - e.width)
            if newDelta < bestDelta,
                let URLString = e.urlString,
                let url = URL(string: URLString) {

                bestDelta = newDelta
                bestURL = url
            }
        }

        return bestURL
    }

    func largest() -> URL? {
        let item = self.max { $0.width < $1.width }
        var largestImageURL: URL?
        if let urlString = item?.urlString,
            let url = URL(string: urlString) {
            largestImageURL = url
        }
        return largestImageURL
    }

    func smallest() -> URL? {
        let item = self.min { $0.width > $1.width }
        var smallestImageURL: URL?
        if let urlString = item?.urlString,
            let url = URL(string: urlString) {
            smallestImageURL = url
        }
        return smallestImageURL

    }
}
