//
//  AssetService.swift
//  
//
//  Created by amir.lahav on 22/09/2020.
//

import Foundation
import Photos

class AssetService {
    
    init() { }
    
    func stackAssets(with options: AssetFetchingOptions? = nil) -> Stack<[PHAsset]> {
         let assets = fetchAssets(with: options) |> assetParser
         return chunk(assets: assets, usersAssets: 200, chunkSize: 10) |> stackAssets
    }
    
    /// Fetch assets from device gallery
    /// - Parameter options: Options for fetching assests like max number of photos, sorting options etc.
    func fetchAssets(with options: AssetFetchingOptions? = nil) -> PHFetchResult<PHAsset> {
        return fetchAssets(with: options ?? AssetFetchingOptions())
    }
}

private extension AssetService {
    
    private func stackAssets(chuncks: [[PHAsset]]) -> Stack<[PHAsset]> {
        var stack = Stack<[PHAsset]>()
        chuncks.forEach({ stack.push($0) })
        return stack
    }
    
    private func chunk(assets:[PHAsset], usersAssets:Int, chunkSize:Int) -> [[PHAsset]] {
        assets.prefix(usersAssets).chunked(into: chunkSize)
    }
    
    func assetParser(asstes: PHFetchResult<PHAsset>) -> [PHAsset] {
        var assets:[PHAsset] = []
        asstes.enumerateObjects { (asset, _, _) in
            if !(asset.mediaSubtypes == .photoScreenshot) {
                assets.append(asset)
            }
        }
        return assets
    }
    
    func fetchAssets(with options: AssetFetchingOptions) -> PHFetchResult<PHAsset> {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = options.sortDescriptors
//        fetchOption.predicate = options.predicate
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
