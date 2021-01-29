//
//  File.swift
//  
//
//  Created by Amir Lahav on 29/01/2021.
//

import Foundation
import UIKit

protocol ProcessAssetsProtocol {
    var identifier: String { get }
    var image: UIImage { get }
}

struct ProcessAsset: ProcessAssetsProtocol {
    let identifier: String
    let image: UIImage
    let tags: [String]
    let faceQuality: Float
    let observation: [CGRect]
}

struct CustomProcessAsset: ProcessAssetsProtocol {
    let identifier: String
    let image: UIImage
}

struct ProcessedAsset {
    let localIdentifier: String
    let faceQuality: Float
    let categories: [String]
    let boundingBoxes: [CGRect]
    init(asset: ProcessAsset) {
        self.localIdentifier = asset.identifier
        self.faceQuality = asset.faceQuality
        self.categories = asset.tags
        self.boundingBoxes = asset.observation
    }
}
