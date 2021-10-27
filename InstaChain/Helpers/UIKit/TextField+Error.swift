//
//  TextField+Error.swift
//  Putbak
//
//  Created by WWK on 4/5/18.
//  Copyright © 2018 WWK. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialSnackbar

private var errorKey: UInt8 = 0
private var oldViewKey: UInt = 1
private var modeKey: UInt = 2

extension UITextField {
    func setError(_ error: String?) {
        if error != nil {
            let oldError = objc_getAssociatedObject(self, &errorKey) as? String
            objc_setAssociatedObject(self, &errorKey, error, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if oldError != nil {
                return
            }
            
            if let oldView = self.rightView {
                objc_setAssociatedObject(self, &oldViewKey, oldView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            objc_setAssociatedObject(self, &modeKey, self.rightViewMode, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            OperationQueue.current?.addOperation {
                let errorButton = UIButton(frame: CGRect(x: 0, y: 0, width: Constants.Field.errorButtonSize, height: Constants.Field.errorButtonSize))
                errorButton.setImage(Asset.errorMark.image, for: .normal)
                errorButton.tintColor = .red
                errorButton.addTarget(self, action: #selector(self.showError(_:)), for: .touchUpInside)
                
                self.rightView = errorButton
                self.rightViewMode = .always
            }
        } else {
            let oldView = objc_getAssociatedObject(self, &oldViewKey) as? UIView
            objc_setAssociatedObject(self, &errorKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            OperationQueue.current?.addOperation {
                self.rightView = oldView
                if let oldMode = objc_getAssociatedObject(self, &modeKey) as? UITextField.ViewMode {
                    self.rightViewMode = oldMode
                }
            }
        }
    }
    
    @objc internal func showError(_ sender: UIButton) {
        guard let error = objc_getAssociatedObject(self, &errorKey) as? String else {
            return
        }
        
        let snackbarMessage = MDCSnackbarMessage()
        snackbarMessage.text = error
        MDCSnackbarManager.show(snackbarMessage)
    }
    
}
