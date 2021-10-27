//
//  ProfileCoordinator.swift
//  InstaChain
//
//  Created by Pei on 2019/5/10.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit

class ProfileCoordinator: BaseCoordinator {
    
    typealias Router = UINavigationController
    
    private var router: Router
    private let context: AppContext
    private let user: User
    
    // MARK: - Lifecycle
    
    init(router: Router, context: AppContext, user: User) {
        self.router = router
        self.context = context
        self.user = user
    }
    
    // MARK: - Public methods
    
    override func start() {
        if user == context.authService.currentUser.value {
            self.startMyProfile()
        } else {
            self.startProfile()
        }
    }
    
    // MARK: - Workflow steps
    
    private func startProfile() {
        let viewController = self.makeProfileModule()
        self.router.pushViewController(viewController, animated: true)
    }
    
    private func makeProfileModule() -> UIViewController {
        let viewController = StoryboardScene.Main.profileViewController.instantiate()
        let viewModel = ProfileViewModel(context: self.context, user: user)
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func startMyProfile() {
        let viewController = self.makeMyProfileModule()
        self.router.pushViewController(viewController, animated: true)
    }
    
    private func makeMyProfileModule() -> UIViewController {
        let viewController = StoryboardScene.Main.profileViewController.instantiate()
        let viewModel = ProfileViewModel(context: self.context, user: context.authService.currentUser.value!)
        viewModel.onEditProfile = {
            self.startEditProfile()
        }
        viewModel.onSettings = {
            self.startSettings()
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func startEditProfile() {
        let viewController = self.makeEditProfileModule()
        let navController = UINavigationController(rootViewController: viewController)
        self.router.present(navController, animated: true, completion: nil)
    }
    
    private func makeEditProfileModule() -> UIViewController {
        let viewController = StoryboardScene.Main.editProfileViewController.instantiate()
        let viewModel = EditProfileViewModel(context: self.context)
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func startSettings() {
        let viewController = self.makeSettingsModule()
        self.router.pushViewController(viewController, animated: true)
    }
    
    private func makeSettingsModule() -> UIViewController {
        let viewController = StoryboardScene.Main.settingsViewController.instantiate()
        let viewModel = SettingsViewModel(context: self.context)
        viewController.viewModel = viewModel
        return viewController
    }

}
