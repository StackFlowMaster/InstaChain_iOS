//
//  LoginViewModel.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import RxSwift
import RxCocoa

class AuthViewModel: BaseViewModel {
    
    typealias Context = UserAuthServiceContext

    var onNavigateSignup: (() -> ())?
    var onNavigateLogin: (() -> ())?
    var onNavigateForgotPassword: (() -> ())?
    
    var onDidLogin: (() -> ())?
    
    var email: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var password: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var confirmPassword: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var fullName: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    var emailError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var passwordError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var confirmError: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var fullNameError: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    private let context: Context
    private let fieldValidator: FieldValidator
    private let disposeBag = DisposeBag()

    init(context: Context) {
        self.context = context
        self.fieldValidator = FieldValidator()
        super.init()
        
        self.bind()
    }
    
    private func bind() {
        self.context.authService.currentUser
            .skip(1)
            .bind { [weak self] user in
                if user != nil {
                    self?.onDidLogin?()
                }
        }.disposed(by: self.disposeBag)
    }
    
    func validateFieldsForLogin() -> Bool {
        var valid = true
        
        if fieldValidator.validateEmail(email.value) {
            emailError.accept(nil)
        } else {
            emailError.accept(L10n.FieldValidation.Error.invalidEmail)
            valid = false
        }
        if fieldValidator.validatePassword(password.value) {
            passwordError.accept(nil)
        } else {
            passwordError.accept(L10n.FieldValidation.Error.shortPassword)
            valid = false
        }

        return valid
    }
    
    func login() {
        context.authService.login(email: email.value!, password: password.value!) { [weak self] (user, error) in
            if let error = error {
                self?.notifications.accept(error.localizedDescription)
            }
        }
    }
    
    func validateFieldsForSignup() -> Bool {
        var valid = true
        
        if fieldValidator.validateEmail(email.value) {
            emailError.accept(nil)
        } else {
            emailError.accept(L10n.FieldValidation.Error.invalidEmail)
            valid = false
        }
        if fieldValidator.validatePassword(password.value) {
            passwordError.accept(nil)
        } else {
            passwordError.accept(L10n.FieldValidation.Error.shortPassword)
            valid = false
        }
        if fieldValidator.validateConfirm(confirmPassword.value, password: password.value) {
            confirmError.accept(nil)
        } else {
            confirmError.accept(L10n.FieldValidation.Error.confirmPassword)
            valid = false
        }
        if fieldValidator.validateEmpty(fullName.value) {
            fullNameError.accept(nil)
        } else {
            fullNameError.accept(L10n.FieldValidation.Error.empty)
            valid = false
        }

        return valid
    }
    
    func validateAgreeTerms(checked: Bool) -> Bool {
        if !checked {
            self.notifications.accept(L10n.SignUp.Error.agreeTerms)
        }
        return checked
    }
    
    func signup() {
        context.authService.signup(email: email.value!, password: password.value!, fullName: fullName.value!) { [weak self] (user, error) in
            if let error = error {
                self?.notifications.accept(error.localizedDescription)
            }
        }
    }
    
    func validateFieldsForResetPassword() -> Bool {
        var valid = true
        
        if fieldValidator.validateEmail(email.value) {
            emailError.accept(nil)
        } else {
            emailError.accept(L10n.FieldValidation.Error.invalidEmail)
            valid = false
        }

        return valid
    }
    
    func resetPassword() {
        context.authService.resetPassword(email: email.value!) { [weak self] error in
            if let error = error {
                self?.notifications.accept(error.localizedDescription)
            } else {
                self?.notifications.accept(L10n.ResetPassword.sentEmail)
            }
        }
    }

}
