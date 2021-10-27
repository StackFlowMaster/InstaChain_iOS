//
//  HomeCoordinator.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    
    typealias Router = UINavigationController

    var onDidLogout: (() -> ())?

    private var router: Router
    private let context: AppContext
    
    // MARK: - Lifecycle
    
    init(router: Router, context: AppContext) {
        self.router = router
        self.context = context
    }
    
    // MARK: - Public methods
    
    override func start() {
        self.startFeed()
    }
    
    // MARK: - Workflow steps
    
    private func startFeed() {
        let viewController = self.makeFeedModule()
        self.router.pushViewController(viewController, animated: true)
    }
    
    private func makeFeedModule() -> UIViewController {
        let viewController = StoryboardScene.Main.homeViewController.instantiate()
        let viewModel = HomeViewModel(context: self.context)
        viewModel.onShowProfile = { user in
            self.startProfile(of: user)
        }
        viewModel.onDidLogout = self.onDidLogout
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func startProfile(of user: User) {
        let profileCoordinator = ProfileCoordinator(router: self.router, context: self.context, user: user)
        profileCoordinator.start()
    }
    
}
