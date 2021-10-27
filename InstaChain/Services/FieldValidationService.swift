//
//  FieldValidationService.swift
//  InstaChain
//
//  Created by Pei on 2019/5/8.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit

class FieldValidator {
    
    func validateEmpty(_ value: String?) -> Bool {
        if value?.isEmpty ?? true {
            return false
        }
        return true
    }
    
    func validateEmail(_ value: String?) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return predicate.evaluate(with: value)
    }
    
    func validatePassword(_ value: String?) -> Bool {
        return (value?.count ?? 0) >= 6
    }
    
    func validateConfirm(_ value: String?, password: String?) -> Bool {
        return value == password
    }
    
    func setFieldError(_ field: UITextField, error: String?) {
        field.setError(error)
//        if error != nil {
//            field.becomeFirstResponder()
//        }
    }

}
