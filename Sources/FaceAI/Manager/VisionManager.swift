//
//  ALVisionManager.swift
//  ALFacerKit
//
//  Created by amir.lahav on 16/11/2019.
//  Copyright © 2019 la-labs. All rights reserved.
//

import Foundation
import Photos
import CoreML
import UIKit

final class VisionManager {
    
    private static let detector = VisionProcessor()

    //MARK: Public API
    
    static func detect(objects stack: Stack<[PHAsset]>, with jobTypes: [VisionProcessType], completion:@escaping(Result<[ProcessedAsset], VisionProcessError>) -> Void) {
        detector.performDetection(stack: stack, jobTypes: jobTypes, completion: completion)
    }
    
    static func detect<T>(in assets: UIImage, model: MLModel, returnType:T.Type, completion: @escaping (Result<T, VisionProcessError>)-> Void) {
        detector.perform(image: assets, model: model, completion: completion)
    }
}
