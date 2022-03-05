//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Миша Перевозчиков on 26.01.2022.
//
//import Foundation
import UIKit

class ImageSaver: NSObject {
    var succesHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            succesHandler?()
        }
    }
}
