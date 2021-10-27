//
//  EditProfileViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/12.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import GrowingTextView
import RxSwift
import SDWebImage
import TZImagePickerController
import SVProgressHUD

class EditProfileViewController: UITableViewController, BaseViewController {

    var viewModel: EditProfileViewModel!
    
    @IBOutlet weak var photoView: UIButton!
    @IBOutlet weak var nameView: UITextField!
    @IBOutlet weak var bioView: GrowingTextView!
    
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bind()
    }
    
    private func bind() {
        viewModel.user
            .bind { [weak self] user in
                guard let self = self else { return }
                if let user = user {
                    self.photoView.sd_setImage(with: user.photoUrl, for: .normal, placeholderImage: UIImage(asset:Asset.profile))
                    self.nameView.text = user.fullName
                    self.bioView.text = user.bio
                }
            }.disposed(by: self.disposeBag)
        viewModel.newPhotoUrl
            .bind { url in
                if let url = url {
                    self.photoView.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(asset:Asset.profile))
                }
            }.disposed(by: self.disposeBag)
        viewModel.notifications
            .bind { [weak self] error in
                self?.present(error: error)
            }.disposed(by: self.disposeBag)
        viewModel.isSaving
            .bind(onNext: { saving in
                if saving {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: self.disposeBag)
        
        nameView.rx.text
            .bind(to: viewModel.newName)
            .disposed(by: self.disposeBag)
        bioView.rx.text
            .bind(to: viewModel.newBio)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Actions

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
            popoverController.sourceView = photoView
            popoverController.sourceRect = CGRect(x: photoView.bounds.midX, y: photoView.bounds.midY, width: 0, height: 0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.saveProfile { [weak self] success in
            if success {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
        viewModel.uploadProfile(photo: photo)
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

extension EditProfileViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        DispatchQueue.main.async {
            self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.frame.size.height = height + 10
        }
    }
}
