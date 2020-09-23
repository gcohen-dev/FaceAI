//
//  File.swift
//  
//
//  Created by amir.lahav on 21/09/2020.
//

import Foundation

class ClusterServiceOptions {
    var maxNumberOfAssetsToProcess: Int = Int.max
    var assetsChunckSize: Int = 10
    var minimumClusterSize: Int = 0
    var maximumFaceDetected: Int = 50
    var ascendingOrder: Bool = true
    var faceSimilarityThreshold: Double = 0.7
}
