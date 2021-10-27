//
//  ChainCell.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import SDWebImage

class ChainCell: UICollectionViewCell {
    
    var onProfile: ((Chain) -> ())?
    var onLike: ((Chain) -> ())?
    var onComment: ((Chain) -> ())?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userPhotoView: UIButton!
    @IBOutlet weak var userDisplayName: UIButton!
    @IBOutlet weak var likeButton: TintButton!
    @IBOutlet weak var commentButton: TintButton!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.sd_cancelCurrentImageLoad()
        userPhotoView.sd_cancelCurrentImageLoad()
    }
    
    @IBAction func showUserProfile(_ sender: Any) {
        onProfile?(self.chain)
    }
    
    @IBAction func like(_ sender: Any) {
        onLike?(self.chain)
    }
    
    @IBAction func comment(_ sender: Any) {
        onComment?(self.chain)
    }
    
    var chain: Chain! {
        didSet {
            if let url = chain.photoUrl {
                imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imageView.sd_setImage(with: url)
            } else {
                imageView.image = nil
            }
            if let url = chain.userPhotoUrl {
                userPhotoView.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(asset: Asset.profileSmall))
            } else {
                userPhotoView.setImage(UIImage(asset: Asset.profileSmall), for: .normal)
            }
            descriptionView.text = chain.description
            userDisplayName.setTitle(chain.userName, for: .normal)
            timeView.text = chain.createdDate?.getElapsedInterval()
        }
    }
    
}
