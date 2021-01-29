//
//  File.swift
//  
//
//  Created by Amir Lahav on 29/01/2021.
//

import Foundation
import Photos

extension Array where Element == PHAsset {
    func processAsset() -> [ProcessAsset]  {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = self.count
        var preProcessPHAssets: [ProcessAsset] = []
        let blocks = self.map { (asset) in
            return BlockOperation {
                let imageFetcher = ImageFetcherService()
                if let image = imageFetcher.image(from: asset) {
                    let assettt = ProcessAsset(identifier: asset.localIdentifier, image: image, tags: [], faceQuality: 0, observation: [])
                    preProcessPHAssets.append(assettt)
                }
            }
        }
        queue.addOperations(blocks, waitUntilFinished: true)
        return preProcessPHAssets
    }
}
