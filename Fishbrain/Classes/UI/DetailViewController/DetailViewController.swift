//
//  DetailViewController.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 24.07.2018.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let catchItem: Catch
    private let viewModel: DetailViewModel
    private let imageService = ImageFetchService.shared

    init(catchItem: Catch) {
        self.catchItem = catchItem
        self.viewModel = DetailViewModel(catchItem: catchItem)
        super.init(nibName: .nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let nib = UINib(nibName: .cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: .reuseID)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.rowHeight
    }
}


extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .reuseID, for: indexPath)
        if let cell = cell as? DetailedInfoItemCell {
            let data = viewModel.detailItem(atIndex: indexPath.row)
            cell.titleLabel.text = data.title
            cell.subtitleLabel.text = data.subtitle
            if let url = data.imageURL {
                cell.customImageView?.isHidden = false
                imageService.fetchImageWith(url: url) { image in
                    cell.customImageView?.image = image
                }
            } else {
                cell.customImageView?.isHidden = true
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}

private extension String {
    static var nibName: String { return "DetailViewController" }
    static var reuseID: String { return "DetailCellReuseID" }
    static var cellNibName: String { return "DetailedInfoItemCell" }
}

private enum Constants {
    static let rowHeight = CGFloat(70)
}
