//
//  MasterModuleAssembly.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 23.07.2018.
//

import UIKit

/// Use this class to build MasterViewController correctly
class MasterModuleAssembly {
    static func buildMasterModule() -> UIViewController {
        let interactor = MasterInteractor(storage: Storage.shared, service: CatchesService())
        let presenter = MasterPresenter(interactor: interactor)
        let view = MasterViewController(presenter: presenter, nibName: nil, bundle: nil)
        let router = MasterRouter()

        router.parentController = view
        presenter.interface = view
        presenter.router = router

        return view
    }
}
