//
//  AppContext.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation

protocol UserAuthServiceContext {
    var authService: UserAuthService { get set }
}
protocol UsersServiceContext {
    var usersService: UsersService { get set }
}
protocol ChainsServiceContext {
    var chainsService: ChainsService { get set }
}
protocol StorageServiceContext {
    var storageService: StorageService { get set }
}

typealias AppContext = UserAuthServiceContext
    & UsersServiceContext
    & ChainsServiceContext
    & StorageServiceContext

class AppContextImpl: AppContext {
    var authService: UserAuthService
    var usersService: UsersService
    var chainsService: ChainsService
    var storageService: StorageService
    
    init() {
        self.usersService = UsersService()
        self.authService = UserAuthService(usersService: usersService)
        self.chainsService = ChainsService()
        self.storageService = StorageService()
    }
}
