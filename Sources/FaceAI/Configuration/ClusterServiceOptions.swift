//
//  File.swift
//  
//
//  Created by amir.lahav on 21/09/2020.
//

import Foundation

public struct ClusterOptions {
    var minimumClusterSize: Int
    var numberIterations: Int
    var faceSimilarityThreshold: Double
    public init(minimumClusterSize: Int = 5,
         numberIterations: Int = 10,
         faceSimilarityThreshold: Double = 0.7) {
        self.minimumClusterSize = minimumClusterSize
        self.numberIterations = numberIterations
        self.faceSimilarityThreshold = faceSimilarityThreshold
    }
}
