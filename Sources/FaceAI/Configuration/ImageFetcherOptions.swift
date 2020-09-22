//
//  ImageFetcherConfiguration.swift
//  
//
//  Created by amir.lahav on 21/09/2020.
//

import Foundation
import Photos

class ImageFetcherOptions {
    
    let downsampleImageSize: CGFloat
    let rquestOptions: PHImageRequestOptions
    
    init(
        downsampleImageSize: CGFloat = 500,
        rquestOptions: PHImageRequestOptions = PHImageRequestOptions.defaultOptions) {
        self.downsampleImageSize = downsampleImageSize
        self.rquestOptions = rquestOptions
    }
    
}
