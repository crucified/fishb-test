//
//  ObjectsUpdaterTests.swift
//  asdfTests
//
//  Created by Denis Kharitonov on 16.07.2018.
//

import XCTest
import CoreData
@testable import Fishbrain

class ObjectsUpdaterTests: XCTestCase {
    let coreData = CoreDataStack.shared
    var decoder: JSONDecoder!

    override func setUp() {
        super.setUp()
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.userInfo[.context] = coreData.context
    }

    func testSmallerObjectIsUpdatedByBiggerObject() {
        // given
        let smallerObject = try! decoder.decode(Catch.self, from: loadData(Constants.filename1))

        // initial object checks
        XCTAssert(smallerObject.caughtAtGMT != nil)
        XCTAssert(smallerObject.caughtAtLocalTimeZone != nil)
        XCTAssert(smallerObject.deepLink != nil)
        XCTAssert(smallerObject.owner != nil)
        XCTAssert(smallerObject.owner!.firstName == nil)
        XCTAssert(smallerObject.owner!.lastName == nil)
        XCTAssert(smallerObject.owner!.nickName == nil)
        XCTAssert(smallerObject.owner!.avatar!.count == 0)

        let biggerObject = try! decoder.decode(Catch.self, from: loadData(Constants.filename2))

        // second object checks
        XCTAssert(biggerObject.caughtAtGMT != nil)
        XCTAssert(biggerObject.caughtAtLocalTimeZone != nil)
        XCTAssert(biggerObject.deepLink != nil)
        XCTAssert(biggerObject.owner != nil)
        XCTAssert(biggerObject.owner!.firstName != nil)
        XCTAssert(biggerObject.owner!.lastName != nil)
        XCTAssert(biggerObject.owner!.nickName != nil)
        XCTAssert(biggerObject.owner!.avatar!.count == 6)

        // when
        ObjectsUpdater.update(smallerObject, with: biggerObject)

        // then
        XCTAssert(smallerObject.caughtAtGMT != nil)
        XCTAssert(smallerObject.caughtAtLocalTimeZone != nil)
        XCTAssert(smallerObject.deepLink != nil)
        XCTAssert(smallerObject.owner != nil)
        XCTAssert(smallerObject.owner!.firstName != nil)
        XCTAssert(smallerObject.owner!.lastName != nil)
        XCTAssert(smallerObject.owner!.nickName != nil)
        XCTAssert(smallerObject.owner!.avatar!.count == 6)

    }

    func testBiggerObjectIsNOTUpdatedBySmallerObject() {
        // given
        let biggerObject = try! decoder.decode(Catch.self, from: loadData(Constants.filename2))

        // initial object checks
        XCTAssert(biggerObject.caughtAtGMT != nil)
        XCTAssert(biggerObject.caughtAtLocalTimeZone != nil)
        XCTAssert(biggerObject.deepLink != nil)
        XCTAssert(biggerObject.owner != nil)
        XCTAssert(biggerObject.owner!.firstName != nil)
        XCTAssert(biggerObject.owner!.lastName != nil)
        XCTAssert(biggerObject.owner!.nickName != nil)
        XCTAssert(biggerObject.owner!.avatar!.count == 6)

        let smallerObject = try! decoder.decode(Catch.self, from: loadData(Constants.filename1))
        // second object checks
        XCTAssert(smallerObject.caughtAtGMT != nil)
        XCTAssert(smallerObject.caughtAtLocalTimeZone != nil)
        XCTAssert(smallerObject.deepLink != nil)
        XCTAssert(smallerObject.owner != nil)
        XCTAssert(smallerObject.owner!.firstName == nil)
        XCTAssert(smallerObject.owner!.lastName == nil)
        XCTAssert(smallerObject.owner!.nickName == nil)
        XCTAssert(smallerObject.owner!.avatar!.count == 0)
        // when
        ObjectsUpdater.update(smallerObject, with: biggerObject)

        // then
        XCTAssert(biggerObject.owner!.avatar!.count == 6)

    }


    private enum Constants {
        static let filename1 = "valid-catch-v1.json"
        static let filename2 = "valid-catch-v2.json"
    }

}
