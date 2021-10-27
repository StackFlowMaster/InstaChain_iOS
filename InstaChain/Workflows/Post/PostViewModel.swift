//
//  PostViewModel.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import RxSwift
import RxCocoa

class PostViewModel: BaseViewModel {
    
    typealias Context = ChainsServiceContext
        & UserAuthServiceContext
        & StorageServiceContext
    
    var onFinishPost: (() -> ())?
    var image: UIImage

    private let context: Context
    private let disposeBag = DisposeBag()
    
    init(context: Context, image: UIImage) {
        self.context = context
        self.image = image
    }
    
    func postChain(image: UIImage, description: String) -> Observable<Double> {
        return Observable<Double>.create { observer -> Disposable in
            self.context.storageService.upload(image: image, onComplete: { [weak self] (url, error) in
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
                    
                    let chain = Chain()
                    chain.photoUrl = url
                    chain.description = description
                    chain.createdDate = Date()
                    if let user = self.context.authService.currentUser.value {
                        chain.userId = user.id
                        chain.userName = user.fullName
                        chain.userPhotoUrl = user.photoUrl
                    }
                    self.context.chainsService.post(chain: chain, onComplete: { error in
                        if let error = error {
                            switch error {
                            case .encodeError:
                                self.notifications.accept(L10n.Post.Error.encode)
                            case .postError:
                                self.notifications.accept(L10n.Post.Error.post)
                            }
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
