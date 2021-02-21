//
//  Face.swift
//  
//
//  Created by Amir Lahav on 14/02/2021.
//

import UIKit
import Vision

public struct Face: Hashable, Identifiable {
    public var id: String {
        localIdnetifier + UUID().uuidString
    }
    
    public let localIdnetifier: String
    let faceID: String
    public let faceCroppedImage: UIImage
    let meanEmbedded: [Double]
    let faceObservation: VNFaceObservation
    let quality: Float
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(localIdnetifier)
    }
}

extension Face {
    func distance(to rhs: Face) -> Double {
        var sum: Double = 0
        for i in 0...meanEmbedded.count-1 {
            sum += (pow(meanEmbedded[i] - rhs.meanEmbedded[i], 2))
        }
       return sqrt(sum)
    }
}
