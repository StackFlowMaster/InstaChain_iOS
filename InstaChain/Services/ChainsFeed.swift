//
//  ChainsFeed.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation
import Firebase
import RxCocoa
import CodableFirebase

protocol ChainsFeed: BaseFeed<Chain> {
    
}

class ChainsFeedAll: BaseFeed<Chain>, ChainsFeed {
    
    override func query() -> Query {
        let db = Firestore.firestore()
        return db.collection(Constants.Database.Collection.chains)
            .order(by: Constants.Database.Field.createdAt, descending: true)
    }
    
}

class ChainsFeedUser: BaseFeed<Chain>, ChainsFeed {
    
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    override func query() -> Query {
        let db = Firestore.firestore()
        return db.collection(Constants.Database.Collection.chains)
            .whereField(Constants.Database.Field.userId, isEqualTo: userId)
            .order(by: Constants.Database.Field.createdAt, descending: true)
    }
    
}

class ChainsFeedMock: BaseFeed<Chain>, ChainsFeed {

    override init() {
        super.init()
        addMockChains()
    }
    
    override func refresh(onComplete: @escaping ((FeedError?) -> ())) {
        isLoading.accept(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.addMockChains()
            self?.isLoading.accept(false)
            self?.hasMore.accept(true)
            onComplete(nil)
        }
    }
    
    override func loadMore(onComplete: @escaping ((FeedError?) -> ())) {
        isLoading.accept(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.addMockChains(append: true)
            self?.isLoading.accept(false)
            onComplete(nil)
        }
    }

    private func addMockChains(append: Bool = false) {
        let chain1 = Chain()
        chain1.photoUrl = URL(string: "https://images.unsplash.com/photo-1556798939-60ea9f2e08f2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2000&q=80")
        chain1.description = "Example"
        chain1.createdDate = Date(timeIntervalSince1970: 1557311052)
        chain1.userId = "user1"
        chain1.userName = "Pei M"
        let chain2 = Chain()
        chain2.photoUrl = URL(string: "https://images.unsplash.com/photo-1556798939-60ea9f2e08f2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2000&q=80")
        chain2.description = "Very long long long long long long long long long long description"
        chain2.createdDate = Date(timeIntervalSince1970: 1551011052)
        chain2.userId = "user2"
        chain2.userName = "Jared Stone"
        if append {
            feed.accept(feed.value + [chain1, chain2])
        } else {
            feed.accept([chain1, chain2])
        }
    }

}

