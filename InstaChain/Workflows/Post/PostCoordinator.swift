//
//  PostCoordinator.swift
//  InstaChain
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import UIKit
import TZImagePickerController

class PostCoordinator: BaseCoordinator {
    
    typealias Router = UIViewController
    
    var onFinishPost: (() -> ())?
    
    private var router: Router
    private let context: AppContext
    
    // MARK: - Lifecycle
    
    init(router: Router, context: AppContext) {
        self.router = router
        self.context = context
    }
    
    // MARK: - Public methods
    
    override func start() {
        self.startPicker()
    }
    
    // MARK: - Workflow steps
    
    private func startPicker() {
        let viewController = self.makePickerModule()
        router.present(viewController, animated: true, completion: nil)
    }
    
    private func makePickerModule() -> UIViewController {
        let imagePicker = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: nil, pushPhotoPickerVc: true)!
        imagePicker.allowPickingVideo = false
        imagePicker.allowTakeVideo = false
        imagePicker.allowCrop = true
        imagePicker.autoDismiss = false
        let size = min(imagePicker.view.tz_width, imagePicker.view.tz_height)
        imagePicker.cropRect = CGRect(x: (imagePicker.view.tz_width - size) / 2, y: (imagePicker.view.tz_height - size) / 2, width: size, height: size)

        imagePicker.didFinishPickingPhotosHandle = { [weak self] (photos, assets, isSelectOriginalPhoto) in
            guard let self = self else { return }
            
            if let photo = photos?.first {
                self.startPost(with: photo, in: imagePicker)
            } else {
                imagePicker.dismiss(animated: true, completion: nil)
            }
        }
        imagePicker.imagePickerControllerDidCancelHandle = {
            imagePicker.dismiss(animated: true, completion: nil)
        }
        return imagePicker
    }
    
    private func startPost(with photo: UIImage, in picker: TZImagePickerController) {
        let viewController = self.makePostModule(with: photo)
        picker.pushViewController(viewController, animated: true)
    }
    
    private func makePostModule(with photo: UIImage) -> UIViewController {
        let viewController = StoryboardScene.Main.postViewController.instantiate()
        let viewModel = PostViewModel(context: self.context, image: photo)
        viewModel.onFinishPost = { [weak self] in
            viewController.dismiss(animated: true, completion: nil)
            self?.onFinishPost?()
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
}
