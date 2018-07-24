//
//  API+SingleCatch.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 16.07.2018.
//

import Foundation


extension API.Catches {

    class Single: RequestDataType, RequestBuildable {
        typealias CatchCompletion = (Result<Catch>) -> Void

        /// Catch verbosity level
        ///
        /// - brief: brief info about catch
        /// - verbose: the most detailed catch data
        /// - social: catch data with social mixin (like trophies, likes etc)
        enum Verbosity: Int {
            case brief = 1
            case verbose = 2
            case social = 3
        }

        let id: ID
        var path: String { return "catches/\(id)" }
        var method: String { return HTTPMethod.GET.rawValue }
        private let decoder: JSONDecoder

        convenience init(id: ID) {
            self.init(id: id, decoder: DecoderFactory.defaultDecoder)
        }

        init(id: ID, decoder: JSONDecoder) {
            self.id = id
            self.decoder = decoder
        }

        /// Get single catch data
        ///
        /// - Parameters:
        ///   - manager: network manager for network request
        ///   - verbosity: required catch detail level
        ///   - completion: completion callback
        @discardableResult
        func get(manager: NetworkManager = NetworkManager.shared,
                 verbosity: Verbosity,
                 completion: @escaping CatchCompletion) -> Cancellable? {
            var task: Cancellable? = nil
            let params = ["verbosity": verbosity.rawValue]
            do {
                let req = try buildRequest(withParams: params)
                task = manager.requestData(with: req, completion: { result in
                    self.processResponse(result: result, with: completion)
                })
            } catch {
                completion(.failure(error))
            }
            return task
        }

        private func processResponse(result: Result<Data>, with completion: @escaping CatchCompletion) {
            switch result {
            case .success(let data) :
                do {
                    let `catch` = try self.decoder.decode(Catch.self, from: data)
                    completion(.success(`catch`))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
