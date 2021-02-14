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

class VisionProcessor {
    
    var imageFilter = ImageFilter()
    var imageFetcher = ImageFetcherService()
    
    func performDetection(stack: Stack<[ProcessAsset]>, jobTypes: [VisionProcessType], completion: @escaping (Result<[ProcessedAsset], VisionProcessError>)-> Void) {
        DispatchQueue.global().async { [self] in
            do {
                let objects = try stack |> detect(jobTypes: jobTypes) |> mapDetectedObjects
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
    
    func perform<T>(image: UIImage, model:MLModel, completion: @escaping (Result<T,VisionProcessError>)-> Void) {
        let asset = CustomProcessAsset(identifier: "on.localIdentifier", image: image)
        let process:(CustomProcessAsset) throws -> T = imageFilter.custom(model: model)
        do {
            let proccest = try asset |> process
            completion(.success(proccest))
        } catch {
            completion(.failure(.error(error)))
        }
    }
    
    private func mapDetectedObjects(objects:[ProcessAsset]) -> [ProcessedAsset] {
        objects.map (ProcessedAsset.init)
    }
    
    private func detect(jobTypes: [VisionProcessType]) -> (Stack<[ProcessAsset]>) throws -> [ProcessAsset] {
        if jobTypes.isEmpty { fatalError("jobs cannot be empty") }
        return fullPipeProcess(jobTypes: jobTypes)
    }
    
    private func fullPipeProcess(jobTypes: [VisionProcessType]) -> (Stack<[ProcessAsset]>) throws -> [ProcessAsset]  {
        let process = imagesProcessor(types: jobTypes)
        return ImageProcessor.makeStackProcessor(processor: process)
    }
    
    private func imagesProcessor(types: [VisionProcessType]) ->  MultiplePipe<ProcessAsset, ProcessAsset> {
        let filter = types.reduce(imageFilter.filter(type: types[0])) { (result, type) -> VisionFilter in
            return add(filter: result, type: type)
        }
        let imageFetcher = imageFilter.filter(type: .imageFatching)
        let finalFilter = imageFetcher |>> filter
        return ImageProcessor.makeSingleProcessProcessor(preformOn: finalFilter)
    }
    
    private func add(filter:@escaping VisionFilter, type:VisionProcessType) -> VisionFilter {
        return filter |>> imageFilter.filter(type: type)
    }
}
