//
//  MasterRouter.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 24.07.2018.
//

import UIKit



class MasterRouter {

    weak var parentController: UIViewController?

    func showImage(for catchItem: Catch) {
        if let vc = ImageViewController(catchItem: catchItem) {
            let nc = UINavigationController(rootViewController: vc)
            parentController?.navigationController?.present(nc, animated: true, completion: nil)
        }
    }

    func showDetails(for catchItem: Catch) {
        let vc = DetailViewController(catchItem: catchItem)
        parentController?.navigationController?.pushViewController(vc, animated: true)
    }
}
