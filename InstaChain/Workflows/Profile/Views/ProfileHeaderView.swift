//
//  ProfileHeaderView.swift
//  InstaChain
//
//  Created by Pei on 2019/5/10.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var photoView: UIButton!
    @IBOutlet weak var displayNameView: UILabel!
    @IBOutlet weak var bioView: UILabel!
    
    @IBOutlet weak var chainsButton: TwoLineButton!
    @IBOutlet weak var followersButton: TwoLineButton!
    @IBOutlet weak var followingButton: TwoLineButton!
    
    @IBOutlet weak var editButton: RoundButton!
    @IBOutlet weak var followButton: RoundButton!
    
    var user: User? {
        didSet {
            photoView.sd_setImage(with: user?.photoUrl, for: .normal, placeholderImage: UIImage(asset: Asset.profile))
            displayNameView.text = user?.fullName
            bioView.text = user?.bio
            chainsButton.mainTitle = user?.chainsCount.stringValue
            followersButton.mainTitle = user?.followersCount.stringValue
            followingButton.mainTitle = user?.followingCount.stringValue
        }
    }
    
}
