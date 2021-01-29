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

typealias Processor = ([ProcessAsset]) throws -> [ProcessAsset]
typealias StackProcessor = (Stack<[PHAsset]>) throws -> [ProcessAsset]

class VisionProcessor {
    
    var imageFilter = ImageFilter()
    var imageFetcher = ImageFetcherService()
    
    func performDetection(stack: Stack<[PHAsset]>, jobTypes: [VisionProcessType], completion: @escaping (Result<[ProcessedAsset], VisionProcessError>)-> Void) {
        DispatchQueue.global().async {
            do {
                let objects = try self.detect(stack: stack, jobTypes: jobTypes) |> self.mapDetectedObjects
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
        return objects.map (ProcessedAsset.init)
    }
    
    private func detect(stack: Stack<[PHAsset]>, jobTypes: [VisionProcessType]) throws ->  [ProcessAsset] {
        if jobTypes.isEmpty { fatalError("jobs cannot be empty") }
        return try stack |> fullPipeProcess(jobTypes: jobTypes)
    }
    
    private func fullPipeProcess(jobTypes:[VisionProcessType]) -> (Stack<[PHAsset]>) throws -> [ProcessAsset] {
        return imagesProcessor(types: jobTypes) |> stackProcessor
    }
    
    private func stackProcessor(processor: @escaping Processor) -> StackProcessor {
        return processor |> ImageProcessor.createStackProcessor
    }
    
    private func imagesProcessor(types: [VisionProcessType] ) ->  Processor {
        let filter = types.reduce(imageFilter.filter(type: types[0])) { (result, type) -> VisionFilter in
            return add(filter: result, type: type)
        }
        return ImageProcessor.singleProcessProcessor(preformOn: filter)
    }
    
    private func add(filter:@escaping VisionFilter, type:VisionProcessType) -> VisionFilter {
        return filter |>> imageFilter.filter(type: type)
    }
}
