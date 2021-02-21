//
//  ProcessedAsset.swift
//  
//
//  Created by Amir Lahav on 14/02/2021.
//

import UIKit

public struct ProcessedAsset: Hashable {
    public let localIdentifier: String
    public let categories: [String]
    public let boundingBoxes: [CGRect]
    public let faces: [Face]
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(localIdentifier)
    }
    init(asset: ProcessAsset) {
        self.localIdentifier = asset.identifier
        self.categories = asset.tags
        self.boundingBoxes = asset.boundingBoxes
        self.faces = asset.faces
    }
}
