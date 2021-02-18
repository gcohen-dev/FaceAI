//
//  File.swift
//  
//
//  Created by Amir Lahav on 18/02/2021.
//

import Foundation
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import AppKit
#endif
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
    
    
    //MARK: Debug
    var drawFeaturePoints: Bool = true
    
    
    private init() { }
}
