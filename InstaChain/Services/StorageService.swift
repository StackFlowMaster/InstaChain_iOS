//
//  StorageService.swift
//  InstaChain
//
//  Created by Pei on 2019/5/10.
//  Copyright © 2019 WWK. All rights reserved.
//

import Foundation
import Firebase

enum StorageServiceError: Error {
    case invalidImage
    case uploadError
}

class StorageService {
    
    func upload(image: UIImage, onComplete: @escaping ((URL?, StorageServiceError?) -> ()), onProgress: @escaping ((Double) -> ())) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            onComplete(nil, .invalidImage)
            return
        }
        let storage = Storage.storage()
        let photoRef = storage.reference().child(Constants.Storage.photos).child(generateId() + ".jpg")
        self.upload(data: imageData, to: photoRef, onComplete: onComplete, onProgress: onProgress)
    }
    
    func upload(profile image: UIImage, of userId: String, onComplete: @escaping ((URL?, StorageServiceError?) -> ()), onProgress: @escaping ((Double) -> ())) {
        guard let imageData = image.pngData() else {
            onComplete(nil, .invalidImage)
            return
        }
        let storage = Storage.storage()
        let photoRef = storage.reference().child(Constants.Storage.profiles).child(userId + ".png")
        self.upload(data: imageData, to: photoRef, onComplete: onComplete, onProgress: onProgress)
    }

    private func generateId() -> String {
        return UUID().uuidString
    }
    
    private func upload(data: Data, to storage: StorageReference, onComplete: @escaping ((URL?, StorageServiceError?) -> ()), onProgress: @escaping ((Double) -> ())) {
        let uploadTask = storage.putData(data)
        uploadTask.observe(.progress) { snapshot in
            let progress = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            onProgress(progress)
        }
        uploadTask.observe(.failure) { snapshot in
            onComplete(nil, .uploadError)
        }
        uploadTask.observe(.success) { snapshot in
            onProgress(1.0)
            storage.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Image upload error \(error)")
                    onComplete(nil, .uploadError)
                } else {
                    onComplete(url, nil)
                }
            })
        }
    }

}

