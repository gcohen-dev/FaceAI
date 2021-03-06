//
//  File.swift
//  
//
//  Created by Amir Lahav on 18/02/2021.
//

import Foundation
import UIKit

class Defaults {
    
    static let shared = Defaults()
    
    //MARK: Photos
    var fetchLimit: Double = 0
    
    
    
    //MARK: Filter
    enum FeaturePoints {
        case points76
        case points5
    }
    
    var minimumFaceArea: CGFloat = 1200
    var featurePointsAlgorithm: FeaturePoints = .points76
    var minimumFaceScoring: Float = 0.3
    
    
    //MARK: Debug
    var drawFeaturePoints: Bool = false
    var print: Bool = true
    
    private init() { }
}
