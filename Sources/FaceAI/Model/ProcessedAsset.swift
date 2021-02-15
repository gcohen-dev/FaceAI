//
//  ProcessedAsset.swift
//  
//
//  Created by Amir Lahav on 14/02/2021.
//

import UIKit

public struct ProcessedAsset: Hashable {
    public let localIdentifier: String
    let faceQuality: Float
    let categories: [String]
    let boundingBoxes: [CGRect]
    public let faces: [Face]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(localIdentifier)
    }
    init(asset: ProcessAsset) {
        self.localIdentifier = asset.identifier
        self.faceQuality = asset.faceQuality
        self.categories = asset.tags
        self.boundingBoxes = asset.observation
        self.faces = asset.faces
    }
}
