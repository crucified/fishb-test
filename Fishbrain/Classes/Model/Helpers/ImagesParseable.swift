//
//  ImagesParseable.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//

import Foundation

protocol ImagesParseable {

    /// Extract images from container
    ///
    /// - Parameters:
    ///   - container: container with images
    ///   - key: key for ImageContainerData structure
    /// - Returns: NSSet of Image objects, created by container data
    func images<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) -> NSSet
}

extension ImagesParseable {

    func images<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) -> NSSet {
        var output = [Image]()
        if let imagesContainer = try? container.nestedContainer(keyedBy: ImageContainerData.self, forKey: key),
            var sizes = try? imagesContainer.nestedUnkeyedContainer(forKey: .sizes) {

            while sizes.isAtEnd == false {
                if let size = try? sizes.decode(Image.self) {
                    output.append(size)
                }
            }
        }
        return NSSet(array: output)
    }
}
