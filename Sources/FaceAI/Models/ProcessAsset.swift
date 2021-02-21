//
//  File.swift
//  
//
//  Created by Amir Lahav on 29/01/2021.
//

import Foundation
import UIKit
import Vision

protocol ProcessAssetsProtocol {
    var identifier: String { get }
    var image: UIImage { get }
}

public struct ProcessAsset: ProcessAssetsProtocol {
    let identifier: String
    let image: UIImage
    let tags: [String]
    let boundingBoxes: [CGRect]
    let faces: [Face]
}

struct CustomProcessAsset: ProcessAssetsProtocol {
    let identifier: String
    let image: UIImage
}

public struct FaceClusters {
    public let faceID: Int
    public let faces: [Face]
}
