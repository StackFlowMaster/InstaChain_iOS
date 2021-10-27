//
//  User.swift
//  InstaChain
//
//  Created by Pei on 2019/5/7.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation

class User: Codable {
    let id: String
    var fullName: String?
    var photoUrl: URL? = nil
    var bio: String? = nil
    var chainsCount: Int = 0
    var followersCount: Int = 0
    var followingCount: Int = 0

    init(id: String, fullName: String?, photoUrl: URL?) {
        self.id = id
        self.fullName = fullName
        self.photoUrl = photoUrl
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case fullName
        case photoUrl
        case bio
        case chainsCount
        case followersCount
        case followingCount
    }
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
