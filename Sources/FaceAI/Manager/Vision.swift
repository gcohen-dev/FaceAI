//
//  ALVisionProcessor.swift
//
//  Created by amir.lahav on 16/11/2019.
//  Copyright © 2019 la-labs. All rights reserved.
//

import Foundation
import Photos
import CoreML
import UIKit
import LADSA

class Vision {
    
    var imageFilter = VFilter()
    var imageFetcher = ImageFetcherService()
    
    func performDetection(stack: Stack<[ProcessAsset]>, pipe: @escaping Pipe, completion: @escaping (Result<[ProcessedAsset], VisionProcessError>)-> Void) {
        DispatchQueue.global().async { [self] in
            do {
                let objects = try stack |> detect(process: pipe)
                DispatchQueue.main.async {
                    completion(.success(objects))
                }
            }catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
            }
        }
    }
    
    func perform<T>(image: UIImage, model: MLModel, completion: @escaping (Result<T,VisionProcessError>)-> Void) {
        let asset = CustomProcessAsset(identifier: "on.localIdentifier", image: image)
        let process:(CustomProcessAsset) throws -> T = VFilter.custom(model: model)
        do {
            let proccest = try asset |> process
            completion(.success(proccest))
        } catch {
            completion(.failure(.error(error)))
        }
    }
    
    private func detect(process: @escaping Pipe) -> (Stack<[ProcessAsset]>) throws -> [ProcessedAsset] {
        let process = LAStack.makeSingleProcessProcessor(preformOn: process)
        return LAStack.makeStackProcessor(processor: process)
    }
}
