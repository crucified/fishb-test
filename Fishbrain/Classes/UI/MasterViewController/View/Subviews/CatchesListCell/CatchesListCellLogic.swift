//
//  CatchesListCellLogic.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 23.07.2018.
//

import UIKit


class CatchesListCellLogic {

    private let catchService: CatchesServiceProtocol
    private let imagesService: ImageFetchService

    convenience init() {
        self.init(catchService: CatchesService(), imagesService: ImageFetchService.shared)
    }

    init(catchService: CatchesServiceProtocol, imagesService: ImageFetchService) {
        self.catchService = catchService
        self.imagesService = imagesService
    }

    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        imagesService.fetchImageWith(url: url) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    func fetchCatchDetails(id: ID, completion: @escaping (Catch?) -> Void) {
        catchService.getCatch(withID: id) { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    completion(item)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func cancelCatchFetch(id: ID) {
        catchService.cancelCatch(withID: id)
    }

    func cancelImageFetch(url: URL) {
        imagesService.cancelImageFetch(for: url)
    }

}
