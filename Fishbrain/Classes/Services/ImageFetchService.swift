
//
//  ImageFetchService.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 23.07.2018.
//

import UIKit


class ImageFetchService {
    static let shared = ImageFetchService()
    private var runningRequests = [URL: Cancellable]()
    private var cachedImages = [URL: UIImage]()

    func fetchImageWith(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cachedImages[url] {
            completion(cachedImage)
            return
        }

        let request = URLRequest(url: url)
        let task = NetworkManager.shared.requestData(with: request) { [weak self] result in
            self?.runningRequests.removeValue(forKey: url)
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                if image != nil {
                    self?.cachedImages[url] = image!
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        runningRequests[url] = task
    }

    func cancelImageFetch(for url: URL) {
        guard let task = runningRequests[url] else { return }

        task.cancel()
        runningRequests.removeValue(forKey: url)
    }


}
