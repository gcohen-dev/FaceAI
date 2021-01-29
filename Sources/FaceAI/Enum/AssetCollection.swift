//
//  File.swift
//  
//
//  Created by Amir Lahav on 29/01/2021.
//

import Foundation
import Photos

public enum AssetCollection {
    case allAssets
    case albumName(_ name: String)
    case assetCollection(_ collection: PHAssetCollection)
    case identifiers(_ ids: [String])
}
