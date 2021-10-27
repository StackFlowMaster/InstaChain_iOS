//
//  HomeViewModel.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    
    typealias Context = ChainsServiceContext
        & UserAuthServiceContext
    
    var onShowProfile: ((User) -> ())?
    var onDidLogout: (() -> ())?

    let chainsFeed: ChainsFeed = ChainsFeedAll()
    var chains: BehaviorRelay<[Chain]> {
        return self.chainsFeed.feed
    }
    var hasMore: BehaviorRelay<Bool> {
        return self.chainsFeed.hasMore
    }
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private let context: Context
    private let disposeBag = DisposeBag()
    
    init(context: Context) {
        self.context = context
        super.init()
        self.bind()
    }
    
    private func bind() {
        self.chainsFeed.isLoading
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)

        self.context.authService.currentUser
            .skip(1)
            .bind { [weak self] user in
                if user == nil {
                    self?.onDidLogout?()
                }
            }.disposed(by: self.disposeBag)
    }

    func refresh() {
        guard !self.isLoading.value else {
            return
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
    
}
