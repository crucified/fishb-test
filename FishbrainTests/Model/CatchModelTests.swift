//
//  CatchModelTests.swift
//  asdfTests
//
//  Created by Denis Kharitonov on 14.07.2018.
//

import XCTest
@testable import Fishbrain

class CatchModelTests: XCTestCase {
    var decoder: JSONDecoder!

    override func setUp() {
        super.setUp()
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        decoder.userInfo[.context] = CoreDataStack.shared.context
    }
    
    override func tearDown() {
        decoder = nil
        super.tearDown()
    }

    func testV1Creation() {
        // given
        let jsonData = loadData(Constants.v1FileName)

        // when
        do {
            let model = try decoder.decode(Catch.self, from: jsonData)

            //then
            XCTAssert(model.caughtAtGMT != nil)
            XCTAssert(model.caughtAtLocalTimeZone != nil)
            XCTAssert(model.weight == 2.0)
            XCTAssert(model.length == 0.0)
            XCTAssert(model.externalID != nil)
            XCTAssert(model.deepLink != nil)
            XCTAssert(model.owner != nil)
            XCTAssert(model.species != nil)
            XCTAssert(model.bait != nil)
            XCTAssert(model.method != nil)
        } catch {
            XCTAssert(false, "throw error: \(error)")
        }
    }

    func testV2Creation() {
        // given
        let jsonData = loadData(Constants.v2FileName)

        // when
        do {
            let model = try decoder.decode(Catch.self, from: jsonData)

            //then
            XCTAssert(model.caughtAtGMT != nil)
            XCTAssert(model.caughtAtLocalTimeZone != nil)
            XCTAssert(model.weight == 22.68)
            XCTAssert(model.length == 1.37)
            XCTAssert(model.externalID != nil)
            XCTAssert(model.deepLink != nil)
            XCTAssert(model.owner != nil)
            XCTAssert(model.species != nil)
            XCTAssert(model.bait != nil)
            XCTAssert(model.method != nil)
            XCTAssert(model.photos!.count > 0)
            XCTAssert(model.weatherCondition != nil)
            XCTAssert(model.windDirection != nil)

            // owner
            XCTAssert(model.owner!.avatar!.count > 0)
            XCTAssert(model.owner!.firstName != nil)
            XCTAssert(model.owner!.lastName != nil)
            XCTAssert(model.owner!.nickName != nil)

            // bait
            XCTAssert(model.bait!.image!.count > 0)
            XCTAssert(model.bait!.name != nil)
            XCTAssert(model.bait!.localizedName != nil)

            // species
            XCTAssert(model.species!.name != nil)
            XCTAssert(model.species!.species != nil)
            XCTAssert(model.species!.photo!.count > 0)

            // method
            XCTAssert(model.method!.localizedName != nil)
            XCTAssert(model.method!.coverImage!.count > 0)

        } catch {
            XCTAssert(false, "throw error: \(error)")
        }
    }
}

private enum Constants {
    static let v1FileName = "valid-catch-v1.json"
    static let v2FileName = "valid-catch-v2.json"
    static let v3FileName = "valid-catch-v3.json"
}
