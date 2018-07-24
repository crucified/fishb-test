//
//  Requestable.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 09.07.2018.
//

import Foundation

enum RequestError: Error {
    case invalidURLPath
    case unableToBuildURL
}

enum HTTPMethod: String {
    case GET
}

protocol RequestBuildable {
    func buildRequest(withParams params: [String: Any]) throws -> URLRequest
}

protocol RequestDataType {
    var path: String { get }
    var method: String { get }
}

extension RequestBuildable where Self: RequestDataType {
    func buildRequest(withParams params: [String: Any]) throws ->  URLRequest {
        guard var components = URLComponents(string: BaseURLProvider.baseURLString + path) else {
            throw RequestError.invalidURLPath
        }
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let url = components.url else {
            throw RequestError.unableToBuildURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return request
    }
    
}
