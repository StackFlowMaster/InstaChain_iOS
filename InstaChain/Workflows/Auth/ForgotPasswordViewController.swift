//
//  ForgotPasswordViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import RxSwift
import RxBiBinding

class ForgotPasswordViewController: UIViewController, BaseViewController {

    var viewModel: AuthViewModel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var email: UITextField!

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
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
    
    // MARK: - Bindings
    
    private func bind() {
        self.bindFields()
        self.bindErrors()
    }
    
    private func bindFields() {
        (email.rx.text <-> viewModel.email)
            .disposed(by: self.disposeBag)
    }
    
    private func bindErrors() {
        viewModel.notifications.bind { [weak self] error in
            self?.present(error: error)
        }.disposed(by: self.disposeBag)
        
        viewModel.emailError.bind {
            self.email.setError($0)
        }.disposed(by: self.disposeBag)
    }

    // MARK: - Actions
    
    @IBAction func recoverPassword(_ sender: Any) {
        if viewModel.validateFieldsForResetPassword() {
            self.view.endEditing(true)
            viewModel.resetPassword()
        }
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        viewModel.onNavigateLogin?()
    }

}
