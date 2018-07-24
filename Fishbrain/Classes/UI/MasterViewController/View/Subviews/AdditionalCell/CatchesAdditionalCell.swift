//
//  CollectionViewCell.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 23.07.2018.
//

import UIKit

class CatchesAdditionalCell: UICollectionViewCell {

    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var retryButton: UIButton!

    var buttonAction: (() -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        retryButton?.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        errorLabel?.text = ""
        loadingIndicator?.stopAnimating()
        buttonAction = nil
    }

    @objc private func onButtonTapped() {
        buttonAction?()
    }

    func showErrorText(_ text: String) {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        errorLabel.text = text
        errorLabel.isHidden = false
        retryButton.isHidden = false
    }

    func showLoadingIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }
}
