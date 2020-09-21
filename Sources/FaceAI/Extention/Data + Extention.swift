//
//  Data + Extention.swift
//  
//
//  Created by amir.lahav on 21/09/2020.
//

import Foundation

import UIKit

extension Data {
    func downSmaple(to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, imageSourceOptions) else { return nil }
        
        let maxDementionInPixels = Swift.max(pointSize.width ,pointSize.height ) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize:maxDementionInPixels] as CFDictionary
        guard let downsamoledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        let image = UIImage(cgImage: downsamoledImage)
        return image
    }
    
    func downSmaple(to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> CGImage? {
        
        let imageSourceOptions = [kCGImageSourceShouldCache:false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, imageSourceOptions) else { return nil }
        
        let maxDementionInPixels = Swift.max(pointSize.width ,pointSize.height ) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways:true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform:true,
             kCGImageSourceThumbnailMaxPixelSize:maxDementionInPixels] as CFDictionary
        return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)
    }
    
    static func downsample(imageAt imageURL: URL, to pointSize: CGSize) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else { return nil }
        
        let maxDimensionInPixels = Swift.max(pointSize.width, pointSize.height) * UIScreen.main.scale
        let downsampleOptions =  [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                  kCGImageSourceShouldCacheImmediately: true,
                                  kCGImageSourceCreateThumbnailWithTransform: true,
                                  kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        let downsampledImage =   CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        let image = UIImage(cgImage: downsampledImage)
        return image
    }
}
