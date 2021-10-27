//
//  SettingsViewModel.swift
//  InstaChain
//
//  Created by Pei on 2019/5/13.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SettingsViewModel: BaseViewModel {
    
    typealias Context = UserAuthServiceContext
    
    private let context: Context
    
    init(context: Context) {
        self.context = context
    }
    
    func logout() {
        self.context.authService.logout()
    }
}
