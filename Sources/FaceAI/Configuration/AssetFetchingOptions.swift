//
//  AssetFetchingOptions.swift
//  
//
//  Created by amir.lahav on 23/09/2020.
//

import Foundation
import Photos

public class AssetFetchingOptions {
    
    public init(sortDescriptors: [NSSortDescriptor]? = nil,
         assetCollection: AssetCollection = .allAssets,
         fetchLimit: Int = Int.max) {
        self.sortDescriptors = sortDescriptors
        self.assetCollection = assetCollection
        self.fetchLimit = fetchLimit
    }
    let sortDescriptors: [NSSortDescriptor]?
    let assetCollection: AssetCollection
    let fetchLimit: Int
}

