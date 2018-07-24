//
//  MasterCollectionViewDisplayDataManager.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 18.07.2018.
//

import Foundation
import UIKit

protocol MasterCollectionViewDisplayManagerDelegate: class {
    func collectionViewWillReachEnd(_ collectionView: UICollectionView)
    func collectionViewDidSelectCatch(withID id: ID)
    func collectionViewDidSelectImage(forCatchID id: ID)
}


private enum AdditionalCellState {
    case noCell
    case loading
    case loadFailed
}

/// Implements UICollectionViewDataSource+Delegate and proxies necessary events to delegate
final class MasterCollectionViewDisplayDataManager: NSObject {
    var delegate: MasterCollectionViewDisplayManagerDelegate? = nil
    private var additionalCellState: AdditionalCellState = .noCell
    private var catches = [Catch]()
    private weak var collectionView: UICollectionView?

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.registerCells(for: collectionView)
    }


    private func registerCells(for collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: String(describing: CatchesListCell.self), bundle: nil),
                                forCellWithReuseIdentifier: .catchReuseID)
        collectionView.register(UINib(nibName: String(describing: CatchesAdditionalCell.self), bundle: nil),
                                forCellWithReuseIdentifier: .additionalCellReuseID)
    }

    func showLoading() {
        self.additionalCellState = .loading
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertSections(IndexSet(integer: .additionalSection))
        }, completion: nil)
    }

    func showNextPageFail() {
        additionalCellState = .loadFailed
        collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [Constants.additionalSectionIndexPath])
        }, completion: nil)
    }

    func appendCatches(_ newCatches: [Catch]) {
        let needRemoveAdditionalSection = self.additionalCellState != .noCell
        var ipsToInsert = [IndexPath]()
        for i in 0..<newCatches.count {
            let ip = IndexPath(row: self.catches.count + i, section: .defaultSection)
            ipsToInsert.append(ip)
        }

        self.additionalCellState = .noCell
        self.catches.append(contentsOf: newCatches)
        
        collectionView?.performBatchUpdates({
            if needRemoveAdditionalSection {
                self.collectionView?.deleteSections(IndexSet(integer: .additionalSection))
            }
            self.collectionView?.insertItems(at: ipsToInsert)

        }, completion: nil)
    }
}

extension MasterCollectionViewDisplayDataManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if additionalCellState != .noCell {
            return 2
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == .defaultSection else { return 1 }

        return catches.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == .defaultSection {
            return showCatchCell(for: collectionView, at: indexPath, with: catches[indexPath.row])
        } else {
            return showAdditionalCell(for: collectionView, at: indexPath)
        }

    }

    private func showAdditionalCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard additionalCellState != .noCell else {
            fatalError("Inconsitent display manager state - additional cell requested when state is .noCell")
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .additionalCellReuseID, for: indexPath)
        if additionalCellState == .loadFailed {
            (cell as? CatchesAdditionalCell)?.showErrorText("Loading failed. Try again")
        } else if additionalCellState == .loading {
            (cell as? CatchesAdditionalCell)?.showLoadingIndicator()
        }
        return cell
    }

    private func showCatchCell(for collectionView: UICollectionView,
                               at indexPath: IndexPath,
                               with aCatch: Catch) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .catchReuseID, for: indexPath)
        if let cell = cell as? CatchesListCell {
            cell.configre(with: aCatch)
            cell.onImageTap = { [weak self] catchItem in
                self?.delegate?.collectionViewDidSelectImage(forCatchID: catchItem.id)
            }
        }
        return cell
    }
}

extension MasterCollectionViewDisplayDataManager: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _catch = catches[indexPath.row]
        delegate?.collectionViewDidSelectCatch(withID: _catch.id)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        guard indexPath.section == .defaultSection else { return }

        if indexPath.row == catches.count - 1 {
            delegate?.collectionViewWillReachEnd(collectionView)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? CatchesListCell {
            cell.cancelFetching()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * Constants.horizontalContentFraction
        if indexPath.section == .defaultSection {

            let height = collectionView.frame.height * Constants.verticalContentFraction
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: width, height: Constants.additionalCellHeight)
        }
    }
}

private extension String {
    static var catchReuseID: String { return "CatchCell" }
    static var additionalCellReuseID: String { return "AdditionalCell" }
}

private enum Constants {
    static let horizontalContentFraction = CGFloat(0.9)
    static let verticalContentFraction = CGFloat(0.6)
    static let additionalCellHeight = CGFloat(50)
    static let additionalSectionIndexPath = IndexPath.init(row: 0, section: .additionalSection)
}

private extension Int {
    static var defaultSection: Int { return 0 }
    static var additionalSection: Int { return 1 }
}



