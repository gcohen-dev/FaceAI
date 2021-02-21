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
    public static func detect(_ pipe: @escaping VisionFilter,
                              with options: AssetFetchingOptions,
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
    
    public static func cluster(fetchOptions: AssetFetchingOptions,
                               culsterOptions: ClusterOptions, completion: @escaping (Result<[FaceClusters], VisionProcessError>) -> Void) {
        let assets = service.stackAssets(with: fetchOptions)
        let cluster =  VFilter.featureDetection |>> VFilter.imageQuality |>> VFilter.embbedFaces
        let startDate = Date()
        detect(objects: assets, pipe: cluster, completion: { result in
            switch result {
            case .success(let photos):
                let faces = photos.flatMap { (asset) -> [Face] in
                    asset.faces
                }
                let labels = ChineseWhispers.chinese_whispers(faces: faces,
                                                              eps: culsterOptions.faceSimilarityThreshold,
                                                              numIterations: culsterOptions.numberIterations)
                
                let groupFaces = ChineseWhispers.group(faces: faces,
                                                       labels: labels).filter({$0.faces.count > culsterOptions.minimumClusterSize })
                print("Finish clustering in: \(startDate.timeIntervalSinceNow * -1) second\nTotal number of faces: \(faces.count)\nTotal number of clusters: \(groupFaces.count)")
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
