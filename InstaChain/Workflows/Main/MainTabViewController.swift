//
//  MainTabViewController.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MainTabViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    private func setup() {
        if let tabBar = self.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = UINavigationController()
        let v2 = UINavigationController()
        let v3 = UINavigationController()
        let v4 = UINavigationController()
        let v5 = UINavigationController()
        
        v1.tabBarItem = ESTabBarItem.init(TabBarBackgroundContentView(), image: UIImage(asset: Asset.home), selectedImage: UIImage(asset: Asset.homeSelected))
        v2.tabBarItem = ESTabBarItem.init(TabBarBackgroundContentView(), image: UIImage(asset: Asset.find), selectedImage: UIImage(asset: Asset.findSelected))
        v3.tabBarItem = ESTabBarItem.init(TabBarBackgroundContentView(specialWithAutoImplies: false), image: UIImage(asset: Asset.photo), selectedImage: UIImage(asset: Asset.photoSelected))
        v4.tabBarItem = ESTabBarItem.init(TabBarBackgroundContentView(), image: UIImage(asset: Asset.favorite), selectedImage: UIImage(asset: Asset.favoriteSelected))
        v5.tabBarItem = ESTabBarItem.init(TabBarBackgroundContentView(), image: UIImage(asset: Asset.me), selectedImage: UIImage(asset: Asset.meSelected))
        
        self.viewControllers = [v1, v2, v3, v4, v5]
    }

}

class TabBarBackgroundContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconColor = UIColor(named: .tabBarIcon)
        highlightIconColor = UIColor(named: .tabBarHighlightIcon)
        backdropColor = UIColor(named: .tabBarBackdrop)
        highlightBackdropColor = UIColor(named: .tabBarHighlightBackdrop)
    }
    
    public convenience init(specialWithAutoImplies implies: Bool) {
        self.init(frame: CGRect.zero)
        iconColor = UIColor(named: .tabBarSpecialIcon)
        highlightIconColor = UIColor(named: .tabBarSpecialHighlightIcon)
        backdropColor = UIColor(named: .tabBarSpecialBackdrop)
        highlightBackdropColor = UIColor(named: .tabBarSpecialHighlightBackdrop)
        if implies {
            let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(TabBarBackgroundContentView.playImpliesAnimation(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc internal func playImpliesAnimation(_ sender: AnyObject?) {
        if self.selected == true || self.highlighted == true {
            return
        }
        let view = self.imageView
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.15, 0.8, 1.15]
        impliesAnimation.duration = 0.3
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        impliesAnimation.isRemovedOnCompletion = true
        view.layer.add(impliesAnimation, forKey: nil)
    }
}
