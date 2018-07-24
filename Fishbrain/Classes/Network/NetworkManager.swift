//
//  NetworkManager.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 09.07.2018.
//

import UIKit

enum Result<T> {
    case success(_: T)
    case failure(_: Error)
}


enum NetworkError: Error {
    case unknownNetworkError // make more sophisticated if needed
}


class NetworkManager {
    static var shared = NetworkManager()
    
    private let session: URLSession

    private convenience init() {
        self.init(session: URLSession.shared)
    }
    
    #if DEBUG
    init(session: URLSession) {
        self.session = session
    }
    #else
    private init(session: URLSession) {
        self.session = session
    }
    #endif

    @discardableResult
    func requestData(with request: URLRequest, completion: @escaping((Result<Data>) -> Void)) -> Cancellable {
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                let underlyingError = error! as NSError
                if underlyingError.code != NSURLErrorCancelled {
                    completion(.failure(error!))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.unknownNetworkError))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
        return dataTask
    }
    
}
