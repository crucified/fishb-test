//
//  CatchesListCell.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 18.07.2018.
//
import UIKit


/*
 I decided not to implement full VIPER stack,
 cause presenter will be a proxy to interactor
 in its most part.
 Just put the logic into a separate class
 */

class CatchesListCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sublabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var currentCatch: Catch?
    private let logic = CatchesListCellLogic()
    private var imageURL: URL?
    private var tapGestureRecognizer: UIGestureRecognizer!
    var onImageTap: ((_ catchItem: Catch) -> Void)?

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTapAction))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        resetCellUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        resetCellUI()
        currentCatch = nil
        activityIndicator.startAnimating()
    }

    func configre(with aCatch: Catch) {
        currentCatch = aCatch
        if let vm = CatchesListCellViewModel(model: aCatch) {
            configure(vm)
        } else {
            getRemoteCatch()
        }
    }

    func cancelFetching() {
        if let id = currentCatch?.id {
            logic.cancelCatchFetch(id: id)
        }

        if let url = imageURL {
            logic.cancelImageFetch(url: url)
        }

        currentCatch = nil
    }

    private func getRemoteCatch() {
        guard let aCatch = currentCatch else { return }
        logic.fetchCatchDetails(id: aCatch.id) { [weak self] catchItem in
            if let item = catchItem,
               let vm = CatchesListCellViewModel(model: item) {
                self?.currentCatch = item
                self?.configure(vm)
            }
        }
    }

    private func configure(_ vm: CatchesListCellViewModel) {
        guard vm.id == currentCatch?.id else { return }
        if let URL = vm.photos.best(toFitWidth: Float(frame.width)) {
            imageURL = URL
            logic.fetchImage(url: URL) { [weak self] image in
                self?.activityIndicator.isHidden = true
                self?.imageView.image = image
            }
        } else {
            activityIndicator.isHidden = true
            imageView.image = UIImage(named: .placeholder)
        }
        label.text = vm.speciesName
        sublabel.text = vm.ownerName
    }

    private func resetCellUI() {
        label.text = ""
        sublabel.text = ""
        imageView.image = nil
        activityIndicator.isHidden = false
    }

    @objc private func onImageTapAction() {
        if let catchItem = self.currentCatch {
            onImageTap?(catchItem)
        }
    }
}


private extension String {
    static var placeholder: String { return "no-photo-placeholder.jpg" }
}
