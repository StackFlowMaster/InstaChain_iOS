//
//  HomeViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HomeViewController: UIViewController, BaseViewController {
    
    var viewModel: HomeViewModel!

    @IBOutlet weak var chainsView: UICollectionView!
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, Chain>>!
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = self.view.bounds.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chainsView.collectionViewLayout = self.flowLayout
        chainsView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAll(_: )), for: .valueChanged)
        
        self.bind()
        viewModel.refresh()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        flowLayout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        flowLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: Privates

    @objc private func refreshAll(_ control: UIRefreshControl) {
        viewModel.refresh()
    }
    
    private func bind() {
        self.bindCollectionView()

        viewModel.isLoading
            .distinctUntilChanged()
            .bind(onNext: { [weak self] loading in
                if !loading {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        viewModel.hasMore
            .distinctUntilChanged()
            .bind { [weak self] hasMore in
                self?.flowLayout.footerReferenceSize = CGSize(width: 0, height: hasMore ? 40 : 0)
//                self?.flowLayout.invalidateLayout()
        }.disposed(by: self.disposeBag)
        
        viewModel.notifications.bind { [weak self] error in
            self?.present(error: error)
        }.disposed(by: self.disposeBag)
    }
    
    private func bindCollectionView() {
//        viewModel.chains
//            .bind(to: chainsView.rx.items(cellIdentifier: "ChainCell", cellType: ChainCell.self)) { (row, chain, cell) in
//                cell.chain = chain
//            }.disposed(by: self.disposeBag)
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Chain>>(configureCell: { (dataSource, collectionView, indexPath, chain) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChainCell", for: indexPath) as! ChainCell
            cell.chain = chain
            cell.onProfile = { chain in
                let user = User(id: chain.userId, fullName: chain.userName, photoUrl: chain.userPhotoUrl)
                self.viewModel.onShowProfile?(user)
            }
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingView", for: indexPath)
            return footer
        })
        viewModel.chains
            .map { (chains) -> [SectionModel<String, Chain>] in
                return [SectionModel(model: "", items: chains)]
            }
            .bind(to: chainsView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        chainsView.rx.didScroll
            .bind {
                if self.viewModel.hasMore.value,
                    !self.viewModel.isLoading.value,
                    self.chainsView.contentOffset.y >= self.chainsView.contentSize.height - self.chainsView.frame.size.height {
                    
                    self.viewModel.loadMore()
                }
        }.disposed(by: self.disposeBag)
//        chainsView.rx.willDisplayCell
//            .bind { (cell, indexPath) in
//                if self.viewModel.hasMore.value, !self.viewModel.isLoading.value, indexPath.row >= self.viewModel.chains.value.count - 1 {
//                    self.viewModel.loadMore()
//                }
//        }.disposed(by: self.disposeBag)
    }

}
