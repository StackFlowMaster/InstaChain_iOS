//
//  AppCoordinator.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class AppCoordinator: BaseCoordinator {
    
    let window: UIWindow
    var context: AppContext
    
    private var loginCoordinator: AuthCoordinator?
    private var mainCoordinator: MainCoordinator?
    
    // MARK: - Lifecycle
    
    init(window: UIWindow, context: AppContext) {
        self.window = window
        self.context = context
    }
    
    // MARK: - Public methods
    
    override func start() {
        if context.authService.currentUser.value == nil {
            startLoginWorkflow()
        } else {
            startMainWorkflow()
        }
    }
    
    // MARK: - Workflow steps
    
    private func startLoginWorkflow(animated: Bool = false) {
        let navController = UINavigationController()
        let coordinator = AuthCoordinator(router: navController, context: self.context)

        self.addDependency(coordinator)
        self.loginCoordinator = coordinator
        coordinator.onDidLogin = { [weak self] in
            self?.startMainWorkflow(animated: true)
            self?.removeDependency(coordinator)
            self?.loginCoordinator = nil
        }

        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window.rootViewController = navController
            })
        } else {
            self.window.rootViewController = navController
        }
        coordinator.start()
    }
    
    private func startMainWorkflow(animated: Bool = false) {
        let tabBarController = MainTabViewController()
        let coordinator = MainCoordinator(router: tabBarController, context: self.context)
        
        self.addDependency(coordinator)
        self.mainCoordinator = coordinator
        coordinator.onDidLogout = { [weak self] in
            self?.startLoginWorkflow(animated: true)
            self?.removeDependency(coordinator)
            self?.mainCoordinator = nil
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window.rootViewController = tabBarController
            })
        } else {
            self.window.rootViewController = tabBarController
        }
        coordinator.start()
    }
    
}
