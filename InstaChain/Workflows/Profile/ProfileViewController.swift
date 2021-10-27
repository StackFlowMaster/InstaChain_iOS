//
//  ProfileViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/10.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import TZImagePickerController
import SVProgressHUD

class ProfileViewController: UIViewController, BaseViewController {
    
    fileprivate static let headerViewHeight = CGFloat(230)
    
    var viewModel: ProfileViewModel!
    
    @IBOutlet weak var chainsView: UICollectionView!
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, Chain>>!
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.bounds.width, height: 10)
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
    
    // MARK: Actions

    @IBAction func changePhoto(_ sender: Any) {
        let alertController = UIAlertController(title: L10n.Profile.Photo.title, message: nil, preferredStyle: .actionSheet)
        if viewModel.hasPhoto {
            alertController.addAction(UIAlertAction(title: L10n.Profile.Photo.change, style: .default) { action in
                self.showPicker()
            })
        } else {
            alertController.addAction(UIAlertAction(title: L10n.Profile.Photo.add, style: .default) { action in
                self.showPicker()
            })
        }
        alertController.addAction(UIAlertAction(title: L10n.General.Action.cancel, style: .cancel, handler: nil))
        if let popoverController = alertController.popoverPresentationController {
            let sourceView: UIView
            if let headerView = self.chainsView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? ProfileHeaderView {
                sourceView = headerView.photoView
            } else {
                sourceView = self.view
            }
            popoverController.sourceView = sourceView
            popoverController.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editProfile(_ sender: Any) {
        viewModel.onEditProfile?()
    }
    
    @IBAction func openSettings(_ sender: Any) {
        viewModel.onSettings?()
    }
    
    // MARK: Privates
    
    @objc private func refreshAll(_ control: UIRefreshControl) {
        viewModel.refresh()
    }
    
    private func bind() {
        self.bindCollectionView()
        self.bindUserProfile()
        
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
                guard let self = self else { return }
                self.flowLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: hasMore ? 40 : 0)
            }.disposed(by: self.disposeBag)
        
        viewModel.notifications
            .bind { [weak self] error in
                self?.present(error: error)
            }.disposed(by: self.disposeBag)
        if !viewModel.isMe || self.navigationController?.viewControllers.first != self {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func bindUserProfile() {
        viewModel.user
            .bind { [weak self] user in
                guard let self = self else { return }
                
                if let bioString = user.bio {
                    self.flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: ProfileViewController.headerViewHeight + bioString.height(withConstrainedWidth: self.view.bounds.width, font: UIFont.systemFont(ofSize: 14)))
                } else {
                    self.flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: ProfileViewController.headerViewHeight)
                }
                if let headerView = self.chainsView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? ProfileHeaderView {
                    self.setup(headerView: headerView)
                }
                let invalidateContext = UICollectionViewFlowLayoutInvalidationContext()
                invalidateContext.invalidateSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader, at: [IndexPath(item: 0, section: 0)])
                self.flowLayout.invalidateLayout(with: invalidateContext)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindCollectionView() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Chain>>(configureCell: { (dataSource, collectionView, indexPath, chain) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChainCell", for: indexPath) as! ChainCell
            cell.chain = chain
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as! ProfileHeaderView
                self.setup(headerView: header)
                return header
            } else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingView", for: indexPath)
                return footer
            }
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
    }
    
    private func setup(headerView: ProfileHeaderView) {
        headerView.user = viewModel.user.value
        if viewModel.isMe {
            headerView.followButton.isHidden = true
            headerView.editButton.isHidden = false
            headerView.photoView.isUserInteractionEnabled = true
        } else {
            headerView.followButton.isHidden = false
            headerView.editButton.isHidden = true
            headerView.photoView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Profile photo

    private func showPicker() {
        let imagePicker = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: nil, pushPhotoPickerVc: true)!
        imagePicker.allowPickingVideo = false
        imagePicker.allowTakeVideo = false
        imagePicker.allowCrop = true
        imagePicker.needCircleCrop = true
        imagePicker.circleCropRadius = Int(min(imagePicker.view.tz_width, imagePicker.view.tz_height)) / 2
        
        imagePicker.didFinishPickingPhotosHandle = { [weak self] (photos, assets, isSelectOriginalPhoto) in
            if let photo = photos?.first {
                self?.updateProfile(photo: photo)
            }
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func updateProfile(photo: UIImage) {
        SVProgressHUD.show()
        viewModel.changeProfile(photo: photo)
            .subscribe(onNext: { progress in
                if progress >= 1.0 {
                    SVProgressHUD.show(withStatus: L10n.Profile.Update.Status.updating)
                } else {
                    SVProgressHUD.showProgress(Float(progress), status: L10n.Profile.Update.Status.uploading)
                }
            }, onError: { error in
                SVProgressHUD.dismiss()
            }, onCompleted: {
                SVProgressHUD.dismiss()
            }).disposed(by: self.disposeBag)
    }

}
