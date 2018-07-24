//
//  XCTestCaseExtension.swift
//  asdfTests
//
//  Created by Denis Kharitonov on 14.07.2018.
//

import Foundation
import XCTest
@testable import Fishbrain

extension XCTestCase {
    func loadJson(name: String) -> [String: Any] {
        guard let jsonDictionary =
            try? JSONSerialization.jsonObject(with: loadData(name + ".json"), options: []) as? [String: Any] else {
                fatalError("Unable to convert \(name).json to JSON dictionary")
        }
        return jsonDictionary!
    }

    func loadData(_ filename: String) -> Data {
        guard let path = Bundle(for: type(of: self)).url(forResource: filename, withExtension: nil) else {
            fatalError("\(filename) not found")
        }
        guard let data = try? Data(contentsOf: path) else {
            fatalError("Unable to convert \(filename) to Data")
        }
        return data
    }
}
class CancellableMock: Cancellable {

    func cancel() {
    }
}
