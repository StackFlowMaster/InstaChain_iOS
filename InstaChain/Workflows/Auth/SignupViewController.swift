//
//  SignupViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import RxSwift
import RxBiBinding
import M13Checkbox
import SVProgressHUD

class SignupViewController: UIViewController, BaseViewController {

    var viewModel: AuthViewModel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var agreeTerms: M13Checkbox!
    
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
        (password.rx.text <-> viewModel.password)
            .disposed(by: self.disposeBag)
        (confirmPassword.rx.text <-> viewModel.confirmPassword)
            .disposed(by: self.disposeBag)
        (fullName.rx.text <-> viewModel.fullName)
            .disposed(by: self.disposeBag)
    }
    
    private func bindErrors() {
        viewModel.notifications.bind { [weak self] error in
            SVProgressHUD.dismiss()
            self?.present(error: error)
        }.disposed(by: self.disposeBag)
        
        viewModel.emailError.bind {
            self.email.setError($0)
        }.disposed(by: self.disposeBag)
        viewModel.passwordError.bind {
            self.password.setError($0)
        }.disposed(by: self.disposeBag)
        viewModel.confirmError.bind {
            self.confirmPassword.setError($0)
        }.disposed(by: self.disposeBag)
        viewModel.fullNameError.bind {
            self.fullName.setError($0)
        }.disposed(by: self.disposeBag)
    }

    // MARK: - Actions

    @IBAction func createAccount(_ sender: Any) {
        if viewModel.validateFieldsForSignup(),
            viewModel.validateAgreeTerms(checked: agreeTerms.checkState == .checked) {
            
            self.view.endEditing(true)
            SVProgressHUD.show()
            viewModel.signup()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        viewModel.onNavigateLogin?()
    }
    
}
