//
//  Constants.swift
//  Putbak
//
//  Created by WWK on 4/2/18.
//  Copyright © 2018 WWK. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Field {
        static let errorButtonSize = 30
    }
    struct Database {
        struct Collection {
            static let chains = "chains"
            static let users = "users"
        }
        struct Field {
            static let createdAt = "createdAt"
            static let userId = "userId"
        }
        struct Feed {
            static let limit = 3
        }
    }
    struct Storage {
        static let photos = "photos"
        static let profiles = "profiles"
    }
}
