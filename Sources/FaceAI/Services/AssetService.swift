//
//  AssetService.swift
//  
//
//  Created by amir.lahav on 22/09/2020.
//

import Foundation
import Photos

public class AssetService {
    
    /// Fetch assets from device gallery
    /// - Parameter options: Options for fetching assests like max number of photos, sorting options etc.
    public static func fetchAssets(with options: AssetFetchingOptions? = nil) -> PHFetchResult<PHAsset> {
        return fetchAssets(with: options ?? AssetFetchingOptions())
    }
    
    public enum AssetCollection {
        case allAssets
        case albumName(_ name: String)
        case assetCollection(_ collection: PHAssetCollection)
        case identifiers(_ ids: [String])
    }
}

private extension AssetService {
    
    private func fetchAssets(with options: AssetFetchingOptions) -> PHFetchResult<PHAsset> {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = options.sortDescriptors
        fetchOption.predicate = options.predicate
        switch options.assetCollection {
        case .allAssets:
            return PHAsset.fetchAssets(with: fetchOption)
        case .albumName(let albumName):
            fetchOption.predicate = NSPredicate(format: "title = %@", albumName)
            let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOption)
            if fetchResult.firstObject == nil { fatalError("no album name:\(albumName) found)") }
            return PHAsset.fetchAssets(in: fetchResult.firstObject!, options: fetchOption)
        case .assetCollection(let assetsCollection):
            return PHAsset.fetchAssets(in: assetsCollection, options: fetchOption)
        case .identifiers(let identifiers):
            return PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOption)
        }
    }
}
