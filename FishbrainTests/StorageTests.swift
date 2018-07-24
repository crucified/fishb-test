//
//  StorageTests.swift
//  asdfTests
//
//  Created by Denis Kharitonov on 15.07.2018.
//

import XCTest
import CoreData
@testable import Fishbrain

class StorageTests: XCTestCase {

    let coreData = CoreDataStack.shared
    let storage = Storage.shared
    var jsonData: Data!
    var decoder: JSONDecoder!

    override func setUp() {
        super.setUp()
        jsonData = loadData(Constants.filename1)
        decoder = JSONDecoder()
        decoder.userInfo[.context] = coreData.context
        removeAllRecordsFromDatabase()
    }
    
    override func tearDown() {
        decoder = nil
        jsonData = nil
        super.tearDown()
    }
    
    func testUpsertInsertsNewRecord() {
        // given
        let newCatch = try! decoder.decode(Catch.self, from: jsonData)

        // when
        storage.upsert(aCatch: newCatch)

        // then
        XCTAssert(fetchAll(fromEntity: Constants.catchEntity).count == 1, "current count: \(fetchAll(fromEntity: Constants.catchEntity).count)")
        XCTAssert(fetchAll(fromEntity: Constants.ownerEntity).count == 1)
        XCTAssert(fetchAll(fromEntity: Constants.baitEntity).count == 1)
        XCTAssert(fetchAll(fromEntity: Constants.methodEntity).count == 1)
    }


    func testUpsertTwiceSavesOneRecord() {
        // given
        let catch1 = try! decoder.decode(Catch.self, from: jsonData)
        let catch2 = try! decoder.decode(Catch.self, from: jsonData)

        // when
        storage.upsert(aCatch: catch1)
        storage.upsert(aCatch: catch2)

        // then
        XCTAssert(fetchAll(fromEntity: Constants.catchEntity).count == 1, "current count: \(fetchAll(fromEntity: Constants.catchEntity).count)")
        XCTAssert(fetchAll(fromEntity: Constants.ownerEntity).count == 1)
        XCTAssert(fetchAll(fromEntity: Constants.baitEntity).count == 1)
        XCTAssert(fetchAll(fromEntity: Constants.methodEntity).count == 1)

    }

    private func removeAllRecordsFromDatabase() {
        coreData.context.reset()
    }

    private func fetchAll(fromEntity entityName: String) -> [Any] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let result = try! coreData.context.fetch(request)
        return result
    }
}

private enum Constants {
    static let filename1 = "valid-catch-v1.json"
    static let catchEntity = "Catch"
    static let ownerEntity = "Owner"
    static let baitEntity = "Bait"
    static let methodEntity = "Method"
}
