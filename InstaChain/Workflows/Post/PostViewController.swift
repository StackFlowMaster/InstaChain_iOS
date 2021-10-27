//
//  PostViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class PostViewController: UIViewController, BaseViewController {
    
    var viewModel: PostViewModel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UIPlaceholderTextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = viewModel.image
        self.bind()
    }
    
    private func bind() {
        viewModel.notifications.bind { [weak self] error in
            self?.present(error: error)
        }.disposed(by: self.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardChangeFrameObserver(willShow: { [weak self] height in
            self?.bottomConstraint.constant = height
            self?.view.layoutIfNeeded()
        }, willHide: { [weak self] height in
            self?.bottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    // MARK: - Actions

    @IBAction func done(_ sender: Any) {
        SVProgressHUD.show()
        viewModel.postChain(image: viewModel.image, description: descriptionView.text)
            .subscribe(onNext: { progress in
                if progress >= 1.0 {
                    SVProgressHUD.show(withStatus: L10n.Post.Status.posting)
                } else {
                    SVProgressHUD.showProgress(Float(progress), status: L10n.Post.Status.uploading)
                }
            }, onError: { error in
                SVProgressHUD.dismiss()
            }, onCompleted: {
                SVProgressHUD.dismiss()
                self.viewModel.onFinishPost?()
            }).disposed(by: self.disposeBag)
    }
    
}
