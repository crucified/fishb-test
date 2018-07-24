//
//  CoreDataStackTests.swift
//  asdfTests
//
//  Created by Denis Kharitonov on 14.07.2018.
//

import Foundation
import XCTest
@testable import Fishbrain

class CoreDataStackTests: XCTestCase {

    func testStackCorrectness() {
        XCTAssertNoThrow(CoreDataStack.shared.model)
        XCTAssertNoThrow(CoreDataStack.shared.persistentStoreCoordinator)
        XCTAssertNoThrow(CoreDataStack.shared.context)
    }
}

