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
import LADSA

public final class FaceAI {
    
    private static let vision = Vision()
    private static let service = AssetService()

    //MARK: Public API
    public static func detect(options: AssetFetchingOptions,
                              pipe: @escaping VisionFilter,
                              completion: @escaping (Result<[ProcessedAsset], VisionProcessError>) -> Void) {
        let assets = service.stackAssets(with: options)
        detect(objects: assets, pipe: pipe, completion: { result in
            switch result {
            case .success(let photos):
                completion(.success(photos))

                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public static func cluster(options: AssetFetchingOptions,
                               culsterOptions: ClusterOptions, completion: @escaping (Result<[Int: [Face]], VisionProcessError>) -> Void) {
        let assets = service.stackAssets(with: options)
        let cluster =  VFilter.featureDetection |>> VFilter.embbedFaces
        detect(objects: assets, pipe: cluster, completion: { result in
            switch result {
            case .success(let photos):
                let faces = photos.flatMap { (asset) -> [Face] in
                    asset.faces
                }
                print("Number of faces found: \(faces.count)")
                let labels = ChineseWhispers.chinese_whispers(faces: faces,
                                                              eps: culsterOptions.faceSimilarityThreshold,
                                                              numIterations: culsterOptions.numberIterations)
                
                let groupFaces = ChineseWhispers.group(faces: faces,
                                                       labels: labels)
                completion(.success(groupFaces))

                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}


private extension FaceAI {
    static func detect(objects stack: Stack<[ProcessAsset]>, pipe: @escaping VisionFilter, completion: @escaping(Result<[ProcessedAsset], VisionProcessError>) -> Void) {
        let pipe = VFilter.filter(type: .imageFatching) |>> pipe |>> VFilter.clean
        vision.performDetection(stack: stack, pipe: pipe, completion: completion)
    }
    
    static func detect<T>(in assets: UIImage, model: MLModel, returnType:T.Type, completion: @escaping (Result<T, VisionProcessError>)-> Void) {
        vision.perform(image: assets, model: model, completion: completion)
    }
}
