//
//  EditProfileViewModel.swift
//  InstaChain
//
//  Created by Pei on 2019/5/12.
//  Copyright © 2019 WWK. All rights reserved.
//

import RxSwift
import RxCocoa

class EditProfileViewModel: BaseViewModel {
    
    typealias Context = UserAuthServiceContext
        & StorageServiceContext

    let user: BehaviorRelay<User?> = BehaviorRelay(value: nil)
    var hasPhoto: Bool {
        return self.user.value?.photoUrl != nil
    }
    
    let newName: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let newBio: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let newPhotoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    var isSaving: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private let context: Context
    private let disposeBag = DisposeBag()
    
    init(context: Context) {
        self.context = context
        super.init()

        self.bind()
    }
    
    private func bind() {
        context.authService.currentUser
            .bind(to: self.user)
            .disposed(by: self.disposeBag)
    }
    
    func uploadProfile(photo: UIImage) -> Observable<Double> {
        return Observable<Double>.create { observer -> Disposable in
            guard let userId = self.user.value?.id else {
                return Disposables.create()
            }
            self.context.storageService.upload(profile: photo, of: userId, onComplete: { [weak self] (url, error) in
                guard let self = self else { return }
                
                if let error = error {
                    switch error {
                    case .invalidImage:
                        self.notifications.accept(L10n.Post.Error.image)
                    case .uploadError:
                        self.notifications.accept(L10n.Post.Error.upload)
                    }
                    observer.onError(error)
                } else {
                    self.newPhotoUrl.accept(url)
                    observer.onCompleted()
                }
            }, onProgress: { progress in
                observer.onNext(progress)
            })
            return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
    }
    
    func saveProfile(callback: @escaping ((Bool) -> ())) {
        guard let userObj = self.user.value else {
            self.notifications.accept(L10n.Profile.Error.noUser)
            return
        }
        self.isSaving.accept(true)

        let newUser = User(id: userObj.id, fullName: newName.value, photoUrl: newPhotoUrl.value)
        newUser.bio = newBio.value
        
        self.context.authService.updateProfile(with: newUser) { error in
            if let error = error {
                self.notifications.accept(error.localizedDescription)
                callback(false)
            } else {
                callback(true)
            }
            self.isSaving.accept(false)
        }
    }

}
