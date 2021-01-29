//
//  AssetFetchingOptions.swift
//  
//
//  Created by amir.lahav on 23/09/2020.
//

import Foundation
import Photos

class AssetFetchingOptions {
    
    init(sortDescriptors: [NSSortDescriptor]? = nil,
                assetCollection: AssetCollection = .allAssets) {
        self.sortDescriptors = sortDescriptors
        self.assetCollection = assetCollection
    }
    let sortDescriptors: [NSSortDescriptor]?
    let assetCollection: AssetCollection
//    let predicate: NSPredicate = NSPredicate(
//        format: "NOT (((mediaSubtype & %d) != 0)",
//        PHAssetMediaSubtype.photoScreenshot.rawValue
//    )
}

