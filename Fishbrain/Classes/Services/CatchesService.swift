//
//  CatchesService.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 10.07.2018.
//

import Foundation

/// Protocol to group functions responsible for fetching catches
protocol CatchesFetchable {
    typealias CatchesListCallback = (Result<[Catch]>) -> Void
    typealias SingleCatchCallback = (Result<Catch>) -> Void

    /// Get page of catches
    ///
    /// - Parameter page: page No
    func catchesList(page: Int, completion: @escaping CatchesListCallback)

    /// Get single catch details.
    /// Details level is the most verbose
    ///
    /// - Parameter id: catch id
    func getCatch(withID id: ID, completion: @escaping SingleCatchCallback)

    /// Get single catch from storage
    ///
    /// - Parameter id: catch id
    /// - Returns: catch item if stored in persistent cache
    func cachedCatch(withID id: ID) -> Catch?
}

/// Protocol to group functions responsible for cancelling a catch fetch
protocol CatchesFetchCancellable {
    /// Cancel the catch details fetch
    ///
    /// - Parameter id: catch id to cancel
    func cancelCatch(withID id: ID)
}

/// Common protocol to work with fetches
protocol CatchesServiceProtocol: CatchesFetchable, CatchesFetchCancellable {

}


class CatchesService {
    private var catchRequests = [ID: Cancellable]()
    private var catchesListRequests = [Int: Cancellable]()
    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    convenience init() {
        self.init(storage: Storage.shared)
    }

}

extension CatchesService: CatchesServiceProtocol {

    func catchesList(page: Int, completion: @escaping CatchesListCallback) {
        guard catchesListRequests[page] == nil else { return }

        guard let request = API.Catches.List(page: page).get(completion: { result in
            self.processCatchesList(result: result)
            self.catchesListRequests.removeValue(forKey: page)
            completion(result)
        }) else { return }

        catchesListRequests[page] = request
    }

    func getCatch(withID id: ID, completion: @escaping SingleCatchCallback) {

        guard catchRequests[id] == nil else { return }
        
        guard let request = API.Catches.Single(id: id).get(verbosity: .verbose, completion: { [weak self] result in
            guard let `self` = self else { return }
            guard self.catchRequests[id] != nil else { return }
            self.processSingleCatch(result: result)
            self.catchRequests.removeValue(forKey: id)
            completion(result)

        }) else { return }

        catchRequests[id] = request
    }

    func cachedCatch(withID id: ID) -> Catch? {
        return storage.aCatch(forID: id)
    }

    func cancelCatch(withID id: ID) {
        guard let request = catchRequests[id] else { return }
        request.cancel()
        catchRequests.removeValue(forKey: id)
    }

    private func processCatchesList(result: Result<Array<Catch>>) {
        switch result {
        case .success(let catches):
            storage.save(catches: catches)
        case .failure(_):
            break

        }
    }

    private func processSingleCatch(result: Result<Catch>) {
        switch result {
        case .success(let _catch):
            storage.upsert(aCatch: _catch)
        case .failure(_):
            break
        }
    }
}
