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
        let options = AssetFetchingOptions(sortDescriptors: nil,
                                           assetCollection: assetCollection)
        let assets = service.stackAssets(with: options)
        
        VisionManager.detect(objects: assets, with: [.cluster]) { (result) in
            switch result {
            case .success(let photos):
                break

            case .failure(let error):
                print(error)
            }
        }
    }
}
