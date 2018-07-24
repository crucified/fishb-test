//
//  MasterInteractor.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 23.07.2018.
//

import Foundation

/// Protocol for events from Presenter
protocol MasterInteractorInput {
    func loadCatchesPage(page: Int, completion: @escaping (Result<[Catch]>) -> Void)
    func storedCatch(withID id: ID) -> Catch?
}

class MasterInteractor {
    let storage: Storage
    let service: CatchesServiceProtocol

    convenience init() {
        let storage = Storage.shared
        let service = CatchesService()
        self.init(storage: storage, service: service)
    }

    init(storage: Storage, service: CatchesServiceProtocol) {
        self.storage = storage
        self.service = service
    }
}


extension MasterInteractor: MasterInteractorInput {
    func loadCatchesPage(page: Int, completion: @escaping (Result<[Catch]>) -> Void) {
        service.catchesList(page: page) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func storedCatch(withID id: ID) -> Catch? {
        return storage.aCatch(forID: id)
    }


}
