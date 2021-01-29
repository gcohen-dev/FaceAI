//
//  FaceAI.swift
//  
//
//  Created by Amir Lahav on 29/01/2021.
//

import Foundation

public class API {
    
    public static func cluster(assetCollection: AssetCollection) {
        let service = AssetService()
        let options = AssetFetchingOptions(sortDescriptors: nil, assetCollection: assetCollection)
        var assets = service.stackAssets(with: options)
        
        VisionManager.detect(objects: assets, with: [.faceDetection, .imageQuality]) { (result) in
            switch result {
            case .success(let photos):
                print(photos.first!)
            case .failure(let error):
                print(error)
            }
        }
    }
}
