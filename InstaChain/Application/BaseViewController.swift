//
//  BaseViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import RxCocoa
import MaterialComponents.MaterialSnackbar

protocol BaseViewController: UIViewController {
    
    func present(error: String, withAction actionTitle: String?, handler actionHandler: (() -> ())?)
    
}

extension BaseViewController {
    internal func present(error: String, withAction actionTitle: String? = nil, handler actionHandler: (() -> ())? = nil) {
        let message = MDCSnackbarMessage()
        message.text = error
        if let title = actionTitle, let handler = actionHandler {
            let action = MDCSnackbarMessageAction()
            action.handler = handler
            action.title = title
            message.action = action
        }
        MDCSnackbarManager.show(message)
    }
}
