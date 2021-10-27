//
//  ChainsService.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation
import Firebase
import RxCocoa
import CodableFirebase

enum ChainsServiceError: Error {
    case encodeError
    case postError
}

class ChainsService {

    func post(chain: Chain, onComplete: @escaping ((ChainsServiceError?) -> ())) {
        let db = Firestore.firestore()
        let documentRef = db.collection(Constants.Database.Collection.chains).document()
        let data: [String: Any]
        do {
            data = try FirestoreEncoder().encode(chain)
        } catch _ {
            onComplete(.encodeError)
            return
        }
        documentRef.setData(data) { (error) in
            if let _ = error {
                onComplete(.postError)
            } else {
                onComplete(nil)
            }
        }
    }
    
}
