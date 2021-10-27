//
//  ProfileViewModel.swift
//  InstaChain
//
//  Created by Pei on 2019/5/10.
//  Copyright © 2019 WWK. All rights reserved.
//

import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    
    typealias Context = UserAuthServiceContext
        & StorageServiceContext
        & UsersServiceContext
    
    var onEditProfile: (() -> ())?
    var onSettings: (() -> ())?
    
    let user: BehaviorRelay<User>
    lazy var isMe: Bool = {
        self.user.value == self.context.authService.currentUser.value
    }()
    var hasPhoto: Bool {
        return self.user.value.photoUrl != nil
    }
    
    let chainsFeed: ChainsFeed
    var chains: BehaviorRelay<[Chain]> {
        return self.chainsFeed.feed
    }
    var hasMore: BehaviorRelay<Bool> {
        return self.chainsFeed.hasMore
    }
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let context: Context
    private let disposeBag = DisposeBag()
    
    init(context: Context, user: User) {
        self.context = context
        self.chainsFeed = ChainsFeedUser(userId: user.id)
        self.user = BehaviorRelay(value: user)
        super.init()
        
        self.bind()
    }
    
    private func bind() {
        self.chainsFeed.isLoading
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        if isMe {
            context.authService.currentUser
                .bind { newUser in
                    if let newUser = newUser {
                        self.user.accept(newUser)
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    func refresh() {
        guard !self.isLoading.value else {
            return
        }
        
        self.context.usersService.fetch(user: user.value.id) { (user, error) in
            if let _ = error {
                self.notifications.accept(L10n.Profile.Error.fetch)
            } else {
                self.user.accept(user!)
            }
        }

        self.chainsFeed.refresh(onComplete: { error in
            if let error = error {
                print("Error in refresh. \(error)")
                self.notifications.accept(L10n.Post.Error.fetch)
            }
        })
    }
    
    func loadMore() {
        guard !self.isLoading.value else {
            return
        }
        
        self.chainsFeed.loadMore(onComplete: { error in
            if let error = error {
                print("Error in load more. \(error)")
                self.notifications.accept(L10n.Post.Error.fetch)
            }
        })
    }
    
    func changeProfile(photo: UIImage) -> Observable<Double> {
        return Observable<Double>.create { observer -> Disposable in
            self.context.storageService.upload(profile: photo, of: self.user.value.id, onComplete: { [weak self] (url, error) in
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
                    self.context.authService.updateProfile(photo: url!, callback: { error in
                        if let error = error {
                            self.notifications.accept(error.localizedDescription)
                            observer.onError(error)
                        } else {
                            observer.onCompleted()
                        }
                    })
                }
            }, onProgress: { progress in
                observer.onNext(progress)
            })
            return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
    }
    
}
