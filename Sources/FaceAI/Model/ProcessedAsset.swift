//
//  ProcessedAsset.swift
//  
//
//  Created by Amir Lahav on 14/02/2021.
//

import UIKit

struct ProcessedAsset {
    let localIdentifier: String
    let faceQuality: Float
    let categories: [String]
    let boundingBoxes: [CGRect]
    let faces: [Face]
    init(asset: ProcessAsset) {
        self.localIdentifier = asset.identifier
        self.faceQuality = asset.faceQuality
        self.categories = asset.tags
        self.boundingBoxes = asset.observation
        self.faces = asset.faces
    }
}
