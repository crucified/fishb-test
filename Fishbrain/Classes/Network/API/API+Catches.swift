//
//  API+Catches.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 15.07.2018.
//

import Foundation

extension API.Catches {

    class List: RequestDataType, RequestBuildable {
        typealias CatchesListCompletion = (Result<Array<Catch>>) -> Void
        let page: Int
        let method: String = HTTPMethod.GET.rawValue
        var path: String { return "catches/" }
        private var decoder: JSONDecoder

        convenience init(page: Int) {
            let decoder = DecoderFactory.defaultDecoder
            self.init(decoder: decoder, page: page)
        }

        init(decoder: JSONDecoder, page: Int) {
            self.decoder = decoder
            self.page = page
        }

        /// get page #`page`
        /// starts task
        /// returns cancellable task
        @discardableResult
        func get(httpManager: NetworkManager = .shared, completion: @escaping CatchesListCompletion) -> Cancellable? {
            var task: Cancellable? = nil
            do {
                let params = ["page": page]
                let request = try buildRequest(withParams: params)
                print("\(#function) url: \(request.url!)")
                task = httpManager.requestData(with: request) {result in
                    self.processResponse(result: result, with: completion)
                }
            } catch {
                completion(.failure(error))
            }
            return task
        }

        private func processResponse(result: Result<Data>, with completion: @escaping CatchesListCompletion) {
            switch result {
            case .success(let data) :
                do {
                    let catches = try self.decoder.decode(Array<Catch>.self, from: data)
                    completion(.success(catches))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
