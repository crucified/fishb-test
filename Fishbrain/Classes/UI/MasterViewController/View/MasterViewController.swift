//
//  MasterViewController.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 09.07.2018.
//

import UIKit

/// Acceptor to change visual state of master view
protocol MasterViewControllerInput: class {
    /// append received catches
    func appendCatches(_ catches: [Catch])

    /// show view for initial loading
    func showLoading()

    /// show view when page is loading
    func showPageLoading()

    /// show view when initial loading failed and no any data
    func showInitialLoadFailed()

    /// show view when next page loading failed, but some data exist
    func showNextPageLoadFailed()

    func showErrorAlert(withText text: String)
}

class MasterViewController: UIViewController {

    private let presenter: MasterViewControllerOutput
    private let collectionView: UICollectionView
    private let initalLoadFailedView: UIView
    private let initialSpinner: UIActivityIndicatorView
    private let layout: UICollectionViewFlowLayout
    private let collectionViewDisplayManager: MasterCollectionViewDisplayDataManager

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let presenter = MasterPresenter()
        self.init(presenter: presenter, nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    init(presenter: MasterViewControllerOutput, nibName: String? = nil, bundle: Bundle? = nil) {
        self.presenter = presenter
        self.layout = UICollectionViewFlowLayout()
        self.layout.scrollDirection = .vertical
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        self.collectionViewDisplayManager = MasterCollectionViewDisplayDataManager(collectionView: self.collectionView)
        self.initalLoadFailedView = UIView(frame: .zero)
        self.initialSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

        super.init(nibName: nil, bundle: nil)
        collectionViewDisplayManager.delegate = self
        collectionView.delegate = collectionViewDisplayManager
        collectionView.dataSource = collectionViewDisplayManager
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("preferred creation with `init()` method")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initialSpinner.color = .black
        collectionView.backgroundColor = .clear
        [collectionView, initalLoadFailedView, initialSpinner].forEach(self.view.addSubview)
        configureConstraints()

        self.initialSpinner.startAnimating()
        showOnly(initialSpinner)
        presenter.loadInitialCatches()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: - Private

    private func showOnly(_ theView: UIView) {
        view.subviews.forEach {
            $0.isHidden = $0 != theView
        }
    }

    private func configureConstraints() {
        let viewsToPin: [UIView] = [collectionView, initalLoadFailedView]

        for v in viewsToPin {
            v.translatesAutoresizingMaskIntoConstraints = false
            v.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            v.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            v.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            v.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        initialSpinner.translatesAutoresizingMaskIntoConstraints = false
        initialSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        initialSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - MasterViewControllerInput

extension MasterViewController: MasterViewControllerInput {
    func appendCatches(_ catches: [Catch]) {

        assert(Thread.current.isMainThread, "this method should be called on main thread")
        initialSpinner.stopAnimating()
        showOnly(collectionView)
        collectionViewDisplayManager.appendCatches(catches)
    }

    func showLoading() {
        assert(Thread.current.isMainThread, "this method should be called on main thread")
        initialSpinner.startAnimating()
        showOnly(initialSpinner)
    }

    func showPageLoading() {
        assert(Thread.current.isMainThread, "this method should be called on main thread")
        showOnly(collectionView)
        collectionViewDisplayManager.showLoading()
    }

    func showInitialLoadFailed() {
        assert(Thread.current.isMainThread, "this method should be called on main thread")
        initialSpinner.stopAnimating()
        showOnly(initalLoadFailedView)
    }

    func showNextPageLoadFailed() {
        assert(Thread.current.isMainThread, "this method should be called on main thread")
        collectionViewDisplayManager.showNextPageFail()
    }

    func showErrorAlert(withText text: String) {
        assert(Thread.current.isMainThread, "this method should be called on main thread")
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - MasterCollectionViewDisplayManagerDelegate

extension MasterViewController: MasterCollectionViewDisplayManagerDelegate {
    func collectionViewWillReachEnd(_ collectionView: UICollectionView) {
        presenter.loadNextPage()
    }

    func collectionViewDidSelectCatch(withID id: ID) {
        presenter.didSelectCatch(withID: id)
    }

    func collectionViewDidSelectImage(forCatchID id: ID) {
        presenter.didSelectDetailedImage(catchID: id)
    }
}
