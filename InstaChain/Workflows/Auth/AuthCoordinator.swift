//
//  AuthCoordinator.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit

class AuthCoordinator: BaseCoordinator {
    
    typealias Router = UINavigationController
    
    var onDidLogin: (() -> ())?
    
    private var router: Router
    private let context: AppContext
    
    // MARK: - Lifecycle
    
    init(router: Router, context: AppContext) {
        self.router = router
        self.context = context
    }
    
    // MARK: - Public methods
    
    override func start() {
        self.startLogin()
    }
    
    // MARK: - Workflow steps
    
    private func startLogin() {
        let viewModel = self.makeAuthViewModel()
        let viewController = self.makeLoginModule(with: viewModel)
        self.router.pushViewController(viewController, animated: true)
    }
    
    private func startSignup() {
        let viewModel = self.makeAuthViewModel()
        let viewController = self.makeSignupModule(with: viewModel)
        self.router.pushViewController(viewController, animated: true)
    }
    
    private func startForgotPassword() {
        let viewModel = self.makeAuthViewModel()
        let viewController = self.makeForgotPasswordModule(with: viewModel)
        self.router.pushViewController(viewController, animated: true)
    }
    
    
    private func makeAuthViewModel() -> AuthViewModel {
        let viewModel = AuthViewModel(context: self.context)
        viewModel.onNavigateSignup = {
            self.startSignup()
        }
        viewModel.onNavigateLogin = {
            self.router.popToRootViewController(animated: true)
        }
        viewModel.onNavigateForgotPassword = {
            self.startForgotPassword()
        }
        viewModel.onDidLogin = self.onDidLogin
        return viewModel
    }
    
    private func makeLoginModule(with viewModel: AuthViewModel) -> UIViewController {
        let viewController = StoryboardScene.Auth.loginViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func makeSignupModule(with viewModel: AuthViewModel) -> UIViewController {
        let viewController = StoryboardScene.Auth.signupViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func makeForgotPasswordModule(with viewModel: AuthViewModel) -> UIViewController {
        let viewController = StoryboardScene.Auth.forgotPasswordViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }

}
