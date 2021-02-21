//
//  AssetService.swift
//  
//
//  Created by amir.lahav on 22/09/2020.
//

import Foundation
import Photos
import UIKit
import LADSA

class AssetService {
    
    init() { }
    
    func stackAssets(with options: AssetFetchingOptions? = nil) -> Stack<[ProcessAsset]> {
         let assets = fetchAssets(with: options) |> assetParser
         return chunk(assets: assets, chunkSize: 10) |> stackAssets
    }
    
    /// Fetch assets from device gallery
    /// - Parameter options: Options for fetching assests like max number of photos, sorting options etc.
    func fetchAssets(with options: AssetFetchingOptions? = nil) -> PHFetchResult<PHAsset> {
        return fetchAssets(with: options ?? AssetFetchingOptions())
    }
}

private extension AssetService {
    
    private func stackAssets(chuncks: [[ProcessAsset]]) -> Stack<[ProcessAsset]> {
        var stack = Stack<[ProcessAsset]>()
        chuncks.forEach({ stack.push($0) })
        return stack
    }
    
    private func chunk(assets:[ProcessAsset], chunkSize:Int) -> [[ProcessAsset]] {
        assets.chunked(into: chunkSize)
    }
    
    func assetParser(asstes: PHFetchResult<PHAsset>) -> [ProcessAsset] {
        var assets: [ProcessAsset] = []
        asstes.enumerateObjects { (asset, _, _) in
            if !(asset.mediaSubtypes == .photoScreenshot) {
                let asset = ProcessAsset(identifier: asset.localIdentifier,
                                         image: UIImage(),
                                         tags: [],
                                         boundingBoxes: [],
                                         faces: [])
                assets.append(asset)
            }
        }
        return assets
    }
    
    func fetchAssets(with options: AssetFetchingOptions) -> PHFetchResult<PHAsset> {
        precondition(PHPhotoLibrary.authorizationStatus() == .authorized, "You need to get Photos permissions first.")
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = options.sortDescriptors
        fetchOption.fetchLimit = options.fetchLimit
        switch options.assetCollection {
        case .allAssets:
            return PHAsset.fetchAssets(with: fetchOption)
        case .albumName(let albumName):
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            return PHAsset.fetchAssets(in: collection.firstObject!, options: fetchOption)
        case .assetCollection(let assetsCollection):
            return PHAsset.fetchAssets(in: assetsCollection, options: fetchOption)
        case .identifiers(let identifiers):
            return PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOption)
        }
    }
}
