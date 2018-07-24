//
//  ImageViewController.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 24.07.2018.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    private let imageService = ImageFetchService.shared
    private let photos: [Image]

    init?(catchItem: Catch) {
        if let photos = catchItem.photos?.allObjects as? [Image],
            photos.isEmpty == false {
            self.photos = photos
        } else if let photos = catchItem.species?.photo?.allObjects as? [Image],
            photos.isEmpty == false {
            self.photos = photos
        } else {
            return nil
        }

        super.init(nibName: .nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))

        if let URL = pickBestPhotoURL() {
            imageService.fetchImageWith(url: URL) { [weak self] (image: UIImage?) in
                if let image = image {
                    self?.imageView.image = image
                } else {
                    self?.showPlaceholder()
                }
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        } else {
            showPlaceholder()
        }
    }

    private func showPlaceholder() {
        let image = UIImage(named: .placeholder)
        self.imageView.image = image
    }

    private func pickBestPhotoURL() -> URL? {
        if let url = photos.largest() {
            return url
        } else if let url = photos.best(toFitWidth: Float(UIScreen.main.bounds.width)) {
            return url
        } else if let urlString = photos.last?.urlString {
            return URL(string: urlString)
        }

        return nil
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}

private extension String {
    static var nibName: String { return "ImageViewController" }
    static var placeholder: String { return "no-photo-placeholder" }
}
