//
//  Face.swift
//  
//
//  Created by Amir Lahav on 14/02/2021.
//

import UIKit
import Vision

struct Face {
    let localIdnetifier: String
    let faceID: String
    let faceCroppedImage: UIImage
    let meanEmbedded: [Double]
    let faceFeatures: VNFaceObservation
    let quality: Float
}
