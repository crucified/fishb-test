//
//  APITests.swift
//  asdfTests
//
//  Created by Denis Kharitonov on 09.07.2018.
//

import XCTest
import CoreData
@testable import Fishbrain

class APITests: XCTestCase {
    

    func testCatchesListRequest() {
        //given
        let list = API.Catches.List(page: 1)
        let manager: NetworkManagerMock = NetworkManagerMock()

        //when
        let cancellable = list.get(httpManager: manager, completion: { _ in })
        
        //then
        XCTAssertNotNil(cancellable, "request must not be nil")
        XCTAssertNotNil(manager.currentRequest?.url, "request ULR must not be nil")
        XCTAssert(manager.currentRequest?.url!.absoluteString == "https://rutilus.fishbrain.com/catches/?page=1")
    }
    
    func testCatchesListModel() {
        // given
        let manager: NetworkManagerMock = NetworkManagerMock()
        manager.data = loadData(Constants.catchesListFilename)
        let e = expectation(description: "catches list request")

        // when
        API.Catches.List(decoder: jsonDecoderMock(), page: 1).get(httpManager: manager, completion: { (result) in
            switch result {
            case .success(let catches):
                XCTAssert(catches.count > 0, "there are valid catches in request but none of them returned")
                e.fulfill()
            case .failure(let error):
                XCTAssert(false, "\(error)")
                e.fulfill()
            }
        })
        wait(for: [e], timeout: 1.0)
    }

    func testSingleCatchRequest() {
        //given
        let aCatch = API.Catches.Single(id: 1)
        let manager = NetworkManagerMock()

        //when
        let cancellable = aCatch.get(manager: manager, verbosity: .social) { _ in }

        //then
        XCTAssertNotNil(cancellable, "request must not be nil")
        XCTAssertNotNil(manager.currentRequest?.url, "request ULR must not be nil")
        XCTAssert(manager.currentRequest!.url!.absoluteString == "https://rutilus.fishbrain.com/catches/1?verbosity=3")

    }

    func testSingleCatchModel() {
        // given
        let manager: NetworkManagerMock = NetworkManagerMock()
        manager.data = loadData(Constants.singleCatchFilename)
        let e = expectation(description: "single catch request")

        // when
        API.Catches.Single(id: 1, decoder: jsonDecoderMock()).get(manager: manager, verbosity: .verbose, completion: { result in
            switch result {
            case .success(let aCatch):
                XCTAssert(aCatch.bait != nil, "there is valid bait in request but none of them returned")
                XCTAssert(aCatch.owner != nil, "there is valid owner in request but none of them returned")
                XCTAssert(aCatch.species != nil, "there is valid species in request but none of them returned")
                XCTAssert(aCatch.photos!.count == 13, "13 phtos expected, but found: \(aCatch.photos!.count)")
                e.fulfill()
            case .failure(let error):
                XCTAssert(false, "\(error)")
                e.fulfill()
            }
        })
        wait(for: [e], timeout: 1.0)
    }
    
    private func jsonDecoderMock() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.userInfo[.context] = CoreDataStack.shared.context
        return decoder
    }

    private class NetworkManagerMock: NetworkManager {
        var data: Data? = nil
        var currentRequest: URLRequest? = nil

        init() {
            data = nil
            super.init(session: URLSession.shared)
        }
        override func requestData(with request: URLRequest, completion: @escaping ((Result<Data>) -> Void)) -> Cancellable {
            self.currentRequest = request
            if data != nil {
                completion(.success(data!))
            }
            return CancellableMock()
        }
    }
}

private enum Constants {
    static let catchesListFilename = "valid_catches_list.json"
    static let singleCatchFilename = "valid-catch-v2.json"
}
