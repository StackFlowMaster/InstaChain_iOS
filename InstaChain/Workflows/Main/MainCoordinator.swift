//
//  MainCoordinator.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MainCoordinator: BaseCoordinator {
    
    typealias Router = MainTabViewController
    
    var onDidLogout: (() -> ())?

    private var router: Router
    private let context: AppContext
    
    private var homeCoordinator: HomeCoordinator?
    private var postCoordinator: PostCoordinator?
    private var profileCoordinator: ProfileCoordinator?

    // MARK: - Lifecycle
    
    init(router: Router, context: AppContext) {
        self.router = router
        self.context = context
    }
    
    override func start() {
        self.setupTabController()
        self.setupCoordinators()
    }

    private func setupTabController() {
        let tabBarController = self.router
        tabBarController.shouldHijackHandler = { (_, _, index) in
            return index == 2
        }
        tabBarController.didHijackHandler = { (_, _, _) in
            self.startPost()
        }
    }
    
    private func setupCoordinators(startImmediately: Bool = true) {
        guard let viewControllers = router.viewControllers as? [UINavigationController],
            viewControllers.count == 5 else {
            fatalError("view controllers are not setup properly")
        }
        let homeCoordinator = HomeCoordinator(router: viewControllers[0], context: self.context)
        homeCoordinator.onDidLogout = self.onDidLogout
        self.addDependency(homeCoordinator)
        self.homeCoordinator = homeCoordinator
        
        let profileCoordinator = ProfileCoordinator(router: viewControllers[4], context: self.context, user: context.authService.currentUser.value!)
        self.addDependency(profileCoordinator)
        self.profileCoordinator = profileCoordinator
        
        if startImmediately {
            homeCoordinator.start()
            profileCoordinator.start()
            
            // Placeholder view controllers
            viewControllers[1].pushViewController(UIViewController(), animated: false)
            viewControllers[3].pushViewController(UIViewController(), animated: false)
        }
    }
    
    private func startPost() {
        let coordinator = PostCoordinator(router: self.router, context: self.context)
        coordinator.onFinishPost = {
            self.removeDependency(coordinator)
            self.postCoordinator = nil
        }
        self.addDependency(coordinator)
        self.postCoordinator = coordinator
        coordinator.start()
    }
}
