//
//  ImageFetcherService.swift
//  
//
//  Created by amir.lahav on 21/09/2020.
//

import Foundation
import Photos
import UIKit

final class ImageFetcherService {
    
    private let imgManager = PHImageManager.default()
    private let downsampleSize: CGFloat = 500
    private var rquestOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.version = .current
        return options
    }
    
    func image(frome phAsset: PHAsset) -> UIImage?  {

        return autoreleasepool { () -> UIImage? in
            var myImage:UIImage?
                let semaphore = DispatchSemaphore(value: 0)
                
            if #available(iOS 13, *) {
                imgManager.requestImageDataAndOrientation(for: phAsset, options: rquestOptions) { [self] (data, str, ori, _) in
                    myImage = data?.downSmaple(to: CGSize(width: downsampleSize, height: downsampleSize), scale: UIScreen.main.scale)
                    semaphore.signal()
                }
            } else {
                // Fallback on earlier versions
                imgManager.requestImageData(for: phAsset, options: rquestOptions) { [self] (data, str, ori, _) in
                    myImage = data?.downSmaple(to: CGSize(width: downsampleSize, height: downsampleSize), scale: UIScreen.main.scale)
                    semaphore.signal()
                }
            }
            _ = semaphore.wait(wallTimeout: .distantFuture)
            return myImage
        }
    }
    
    func cgImage(from phAsset: PHAsset) -> CGImage?  {

        return autoreleasepool { () -> CGImage? in
            var myImage:CGImage?
                let semaphore = DispatchSemaphore(value: 0)
                
            if #available(iOS 13, *) {
                imgManager.requestImageDataAndOrientation(for: phAsset, options: rquestOptions) { (data, str, ori, _) in
                    myImage = data?.downSmaple(to: CGSize(width: 500, height: 500), scale: UIScreen.main.scale)
                    semaphore.signal()
                }
            } else {
                // Fallback on earlier versions
                imgManager.requestImageData(for: phAsset, options: rquestOptions) { (data, str, ori, _) in
                    myImage = data?.downSmaple(to: CGSize(width: 500, height: 500), scale: UIScreen.main.scale)
                    semaphore.signal()
                }
            }
                _ = semaphore.wait(wallTimeout: .distantFuture)
            return myImage
        }
    }
}
