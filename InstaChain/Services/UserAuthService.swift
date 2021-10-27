//
//  UserLoginService.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation
import Firebase
import RxCocoa

enum UserAuthServiceError: Error {
    case notSignedIn
}

class UserAuthService {
    
    let currentUser: BehaviorRelay<User?>
    private let usersService: UsersService
    
    init(usersService: UsersService) {
        self.usersService = usersService
        if let firUser = Auth.auth().currentUser {
            let user = User(id: firUser.uid, fullName: firUser.displayName, photoUrl: firUser.photoURL)
            self.currentUser = BehaviorRelay(value: user)
        } else {
            self.currentUser = BehaviorRelay(value: nil)
        }
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.updateCurrentUser(needsFetch: true)
        }
    }
    
    func login(email: String, password: String, callback: ((User?, Error?) -> ())?) {
        Auth.auth().signIn(withEmail: email, password: password) { auth, error in
            if error != nil || auth?.user == nil {
                callback?(nil, error)
                return
            }
            
            let user = User(id: auth!.user.uid, fullName: auth!.user.displayName, photoUrl: auth!.user.photoURL)
            callback?(user, nil)
        }
    }
    
    func signup(email: String, password: String, fullName: String, callback: ((User?, Error?) -> ())?) {
        Auth.auth().createUser(withEmail: email, password: password) { auth, error in
            if error != nil || auth?.user == nil {
                callback?(nil, error)
                return
            }
            
            let changeRequest = auth?.user.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            changeRequest?.commitChanges { [weak self] (error) in
                if let error = error {
                    print(error)
                    return
                }
                self?.saveCurrentUser()
                self?.updateCurrentUser()
            }
            
            auth?.user.sendEmailVerification { (error) in
                if let error = error {
                    print(error)
                }
            }
            
            let user = User(id: auth!.user.uid, fullName: auth!.user.displayName, photoUrl: auth!.user.photoURL)
            callback?(user, nil)
        }
    }
    
    func resetPassword(email: String, callback: ((Error?) -> ())? = nil) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error signing out: %@", error)
        }
    }
    
    func updateProfile(photo url: URL, callback: ((Error?) -> ())?) {
        guard let user = Auth.auth().currentUser else {
            callback?(UserAuthServiceError.notSignedIn)
            return
        }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = url
        changeRequest.commitChanges { [weak self] (error) in
            if let error = error {
                print("Update profile error. \(error)")
                callback?(error)
                return
            }
            if let currentUser = self?.currentUser.value {
                currentUser.photoUrl = url
                self?.currentUser.accept(currentUser)
                self?.usersService.save(user: currentUser, onComplete: nil)
            }
            callback?(nil)
        }
    }
    
    func updateProfile(with user: User, callback: ((Error?) -> ())?) {
        guard let firUser = Auth.auth().currentUser else {
            callback?(UserAuthServiceError.notSignedIn)
            return
        }
        let changeRequest = firUser.createProfileChangeRequest()
        if let url = user.photoUrl {
            changeRequest.photoURL = url
        }
        if let name = user.fullName {
            changeRequest.displayName = name
        }
        changeRequest.commitChanges { [weak self] (error) in
            if let error = error {
                print("Update profile error. \(error)")
                callback?(error)
                return
            }
            if let currentUser = self?.currentUser.value {
                if let url = user.photoUrl {
                    currentUser.photoUrl = url
                }
                if let name = user.fullName {
                    currentUser.fullName = name
                }
                if let bio = user.bio {
                    currentUser.bio = bio
                }
                self?.currentUser.accept(currentUser)
                self?.usersService.save(user: currentUser, onComplete: nil)
            }
            callback?(nil)
        }
    }
    
    private func updateCurrentUser(needsFetch: Bool = false) {
        if let firUser = Auth.auth().currentUser {
            if needsFetch {
                self.usersService.fetch(user: firUser.uid) { (user, error) in
                    if let error = error {
                        print("Fetch user error. \(error)")
                        let userObj = User(id: firUser.uid, fullName: firUser.displayName, photoUrl: firUser.photoURL)
                        self.currentUser.accept(userObj)
                    } else {
                        self.currentUser.accept(user)
                    }
                }
            } else {
                let userObj = User(id: firUser.uid, fullName: firUser.displayName, photoUrl: firUser.photoURL)
                self.currentUser.accept(userObj)
            }
        } else {
            self.currentUser.accept(nil)
        }
    }
    
    private func saveCurrentUser() {
        if let firUser = Auth.auth().currentUser {
            let userObj = User(id: firUser.uid, fullName: firUser.displayName, photoUrl: firUser.photoURL)
            self.usersService.save(user: userObj, onComplete: nil)
        }
    }
    
}
