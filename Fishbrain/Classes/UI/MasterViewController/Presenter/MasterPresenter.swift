//
//  MasterPresenter.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 18.07.2018.
//

import Foundation

/// Acceptor of master view events
protocol MasterViewControllerOutput {

    /// Load catches first page
    func loadInitialCatches()

    /// Event of selecting a catch to see its details
    ///
    /// - Parameter aCatch: catch
    func didSelectCatch(withID id: ID)

    func loadNextPage()

    /// Event of see a detailed image of the catch
    ///
    /// - Parameter catch: catch with image
    func didSelectDetailedImage(catchID id: ID)
}


class MasterPresenter {
    private var currentCatches = [Catch]()
    private var currentPage: Int = Constants.initialPage
    private let interactor: MasterInteractorInput
    private var isPageLoading = false
    weak var interface: MasterViewControllerInput?
    var router: MasterRouter!

    convenience init() {
        let interactor = MasterInteractor()
        self.init(interactor: interactor)
    }

    init(interactor: MasterInteractorInput) {
        self.interactor = interactor
    }
}

extension MasterPresenter: MasterViewControllerOutput {
    func loadInitialCatches() {
        interface?.showLoading()
        currentPage = Constants.initialPage
        loadRemoteCatches() { [weak self] in
            self?.interface?.showInitialLoadFailed()
        }
    }

    func didSelectCatch(withID id: ID) {
        if let item = catchItem(withID: id) {
            router.showDetails(for: item)
        } else {
            interface?.showErrorAlert(withText: Constants.catchNotFoundText)
        }
    }

    func loadNextPage() {
        guard isPageLoading == false else { return }
        isPageLoading = true
        currentPage += 1
        DispatchQueue.main.async {
            self.interface?.showPageLoading()
        }

        loadRemoteCatches { [weak self] in
            self?.interface?.showNextPageLoadFailed()
        }
    }

    func didSelectDetailedImage(catchID id: ID) {

        if let item = catchItem(withID: id) {
            router.showImage(for: item)
        } else {
            interface?.showErrorAlert(withText: Constants.catchNotFoundText)
        }
    }

    private func catchItem(withID id: ID) -> Catch? {
        // stored catch can have more data
        if let catchItem = interactor.storedCatch(withID: id) {
            return catchItem
        } else  if let catchItem = currentCatches.first(where: {$0.id == id}) {
            return catchItem
        }

        return nil
    }


    private func loadRemoteCatches(onError: @escaping () -> Void) {
        interactor.loadCatchesPage(page: currentPage) { [weak self] result in
            self?.isPageLoading = false
            switch result {
            case .success(let catches):
                guard let `self` = self else { return }
                let ids = catches.map { $0.id }
                self.currentCatches.append(contentsOf: catches)
                self.interface?.appendCatches(catches)
            case .failure(_):
                onError()
            }
        }
    }
}

private enum Constants {
    static let initialPage: Int = 1
    static let catchNotFoundText = "Catch not found"
}
