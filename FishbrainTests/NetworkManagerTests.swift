//
//  NetworkManagerTests.swift
//  asdfTests
//
//  Created by Denis Kharitonov on 09.07.2018.
//

import XCTest
@testable import Fishbrain

class NetworkManagerTests: XCTestCase {
    
    let manager = NetworkManager.shared
    
    func testWorkability() {
        //given
        let exp = expectation(description: "network request expectation")
        let url = URL(string: "https://rutilus.fishbrain.com/catches?page=3")!
        let request = URLRequest(url: url)
        
        // when
        manager.requestData(with: request) { result in
            switch result {
            case .success(_):
                //then
                exp.fulfill()
            case .failure(_):
                fatalError("request must succeed")
            }
        }
        
        wait(for: [exp], timeout: Constants.timeout)
    }
    
    private enum Constants {
        static let timeout = TimeInterval(5.0)
    }
    
}
