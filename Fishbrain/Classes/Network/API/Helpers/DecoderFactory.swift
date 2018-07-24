//
//  File.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//

import Foundation

/// Small helper to make decoder.
/// If more API requests appear, fix this trivial decoder to more sophisticated according to requirements
class DecoderFactory {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.userInfo[.context] = CoreDataStack.shared.context
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
