//
//  DetailedInfoItemCell.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 24.07.2018.
//

import UIKit

class DetailedInfoItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        subtitleLabel.text = ""
        customImageView.isHidden = true
    }
}
