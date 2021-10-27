//
//  UsersService.swift
//  InstaChain
//
//  Created by Pei on 2019/5/11.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import RxCocoa
import CodableFirebase

enum UsersServiceError: Error {
    case encodeError
    case decodeError
    case saveError
    case fetchError
    case noData
}

class UsersService {
    
    func save(user: User, onComplete: ((UsersServiceError?) -> ())?) {
        let db = Firestore.firestore()
        let documentRef = db.collection(Constants.Database.Collection.users).document(user.id)
        let data: [String: Any]
        do {
            data = try FirestoreEncoder().encode(user)
        } catch _ {
            onComplete?(.encodeError)
            return
        }
        documentRef.setData(data) { (error) in
            if let _ = error {
                onComplete?(.saveError)
            } else {
                onComplete?(nil)
            }
        }
    }
    
    func fetch(user userId: String, onComplete: @escaping ((User?, UsersServiceError?) -> ())) {
        let db = Firestore.firestore()
        let documentRef = db.collection(Constants.Database.Collection.users).document(userId)
        documentRef.getDocument { (snapshot, error) in
            if let error = error {
                print("Fetch profile error. \(error)")
                onComplete(nil, .fetchError)
            } else {
                guard let data = snapshot!.data() else {
                    onComplete(nil, .noData)
                    return
                }
                guard let user = try? FirestoreDecoder().decode(User.self, from: data) else {
                    onComplete(nil, .decodeError)
                    return
                }
                onComplete(user, nil)
            }

        }
    }
    
}
