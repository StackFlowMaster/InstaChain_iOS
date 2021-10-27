//
//  Chain.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit

class Chain: Codable {
    var photoUrl: URL?
    var description: String?
    var createdAt: TimeInterval?
    var userId: String!
    var userName: String?
    var userPhotoUrl: URL?
    
    // Workaround as parsing Date have a problem
    var createdDate: Date? {
        get {
            return createdAt == nil ? nil : Date(timeIntervalSince1970: createdAt!)
        }
        set {
            createdAt = newValue?.timeIntervalSince1970
        }
    }
}
