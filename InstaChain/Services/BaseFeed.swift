//
//  BaseFeed.swift
//  InstaChain
//
//  Created by Pei on 2019/5/11.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation
import Firebase
import RxCocoa
import CodableFirebase

enum FeedError: Error {
    case fetchError
    case encodeError
    case decodeError
    case postError
}

class BaseFeed<T: Decodable> {
    let feed: BehaviorRelay<[T]> = BehaviorRelay(value: [])
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let hasMore: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var limit = Constants.Database.Feed.limit

    internal var lastSnapshot: DocumentSnapshot?
    
    func refresh(onComplete: @escaping ((FeedError?) -> ())) {
        self.isLoading.accept(true)
        let query = self.query()
        query.limit(to: self.limit)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error getting documents: \(error)")
                    onComplete(.fetchError)
                } else {
                    do {
                        self.lastSnapshot = snapshot!.documents.last
                        let objects = try snapshot!.documents.map({ document in
                            return try FirestoreDecoder().decode(T.self, from: document.data())
                        })
                        self.hasMore.accept(snapshot!.count == Constants.Database.Feed.limit)
                        self.feed.accept(objects)
                        onComplete(nil)
                    } catch let error {
                        print("Error decoding documents: \(error)")
                        onComplete(.decodeError)
                    }
                }
                self.isLoading.accept(false)
        }
    }
    
    func loadMore(onComplete: @escaping ((FeedError?) -> ())) {
        self.isLoading.accept(true)
        let query = self.query()
        if let snapshot = self.lastSnapshot {
            query.start(afterDocument: snapshot)
        }
        query.limit(to: self.limit)
        query.getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
                onComplete(.fetchError)
            } else {
                self.lastSnapshot = snapshot!.documents.last
                do {
                    let objects = try snapshot!.documents.map({ document in
                        return try FirestoreDecoder().decode(T.self, from: document.data())
                    })
                    self.hasMore.accept((snapshot!.count - self.feed.value.count) == self.limit)
                    self.feed.accept(objects) // self.chainsFeed.value + chains
                    onComplete(nil)
                } catch let error {
                    print("Error decoding documents: \(error)")
                    onComplete(.decodeError)
                }
            }
            self.isLoading.accept(false)
        }
    }
    
    internal func query() -> Query {
        fatalError("Subclasses need to implement method")
    }
    
}
