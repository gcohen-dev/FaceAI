//
//  FaceAI.swift
//  
//
//  Created by Amir Lahav on 29/01/2021.
//

import Foundation

public class API {
    
    public static func detect(assetCollection: AssetCollection, completion: @escaping (Result<[ProcessedAsset], VisionProcessError>) -> Void) {
        let service = AssetService()
        let options = AssetFetchingOptions(sortDescriptors: nil,
                                           assetCollection: assetCollection)
        let assets = service.stackAssets(with: options)
        VisionManager.detect(objects: assets, with: [.cluster], completion: { result in
            switch result {
            case .success(let photos):                
                completion(.success(photos))

                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    public static func cluster(assetCollection: AssetCollection, completion: @escaping (Result<[String: [Face]], VisionProcessError>) -> Void) {
        let service = AssetService()
        let options = AssetFetchingOptions(sortDescriptors: nil,
                                           assetCollection: assetCollection)
        let assets = service.stackAssets(with: options)
        VisionManager.detect(objects: assets, with: [.cluster], completion: { result in
            switch result {
            case .success(let photos):
                var faces = photos.flatMap { (asset) -> [Face] in
                    asset.faces
                }
                
                
                
                let dbScan = DBSCAN(aDB: faces)
                
                dbScan.DBSCAN(distFunc: { (a, b) -> Double in
                    a.distance(to: b)
                }, eps: 1.0, minPts: 1)
                faces = dbScan.label.map { (face, id) -> Face in
                    Face(localIdnetifier: face.localIdnetifier, faceID: id, faceCroppedImage: face.faceCroppedImage, meanEmbedded: [], faceFeatures: face.faceFeatures, quality: 0)
                }
                let e = Dictionary(dbScan.label.map({ ($1, [$0]) }), uniquingKeysWith: {
                    (old, new) in old + new
                })
                completion(.success(e))

                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

}
