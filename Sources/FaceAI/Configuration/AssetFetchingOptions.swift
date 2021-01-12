//
//  AssetFetchingOptions.swift
//  
//
//  Created by amir.lahav on 23/09/2020.
//

import Foundation
import Photos

public class AssetFetchingOptions {
    
    var sortDescriptors: [NSSortDescriptor]?
    var assetCollection: AssetService.AssetCollection = .allAssets
    let predicate: NSPredicate = NSPredicate(
        format: "NOT (((mediaSubtype & %d) != 0)",
        PHAssetMediaSubtype.photoScreenshot.rawValue
    )
}

