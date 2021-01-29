//
//  ImageProcessor.swift
//
//  Created by amir.lahav on 16/11/2019.
//  Copyright © 2019 la-labs. All rights reserved.
//

import Foundation
import Photos

class ImageProcessor {
        
    /// Create opertion queue to process all assets.
    /// - Return analized objects
    /// - Parameter images: User Images
    static func imageProcessor<T>(images: [ProcessAsset], preformOn:@escaping (ProcessAsset) throws -> [T]) ->  [T] {
        let queue = OperationQueue()
        var objects:[T] = []
        let blocks = images.map { (image) -> BlockOperation in
            return BlockOperation {
                do {
                    let face = try preformOn(image)
                    objects.append(contentsOf: face)
                }catch {
                    //TODO: handle error
                }
            }
        }
        queue.addOperations(blocks, waitUntilFinished: true)
        return objects
    }
    
    
    /// Create opertion queue to process all assets.
    /// - Return analized objects
    /// - Parameter images: User Images
    static func singleImageProcessor<T>(images:[ProcessAsset], preformOn:@escaping (ProcessAsset) throws -> T) ->  [T] {
        let queue = OperationQueue()
        var objects:[T] = []
        let blocks = images.map { (image) -> BlockOperation in
            return BlockOperation {
                do {
                    let object = try preformOn(image)
                    objects.append(object)
                }catch {
                    //TODO: handle error
                }
            }
        }
        queue.addOperations(blocks, waitUntilFinished: true)
        return objects
    }
    
    /// Create opertion queue to process all assets.
    /// - Return analized objects
    /// - Parameter images: User Images
    static func singleProcessProcessor(preformOn:@escaping (ProcessAsset) throws -> ProcessAsset) ->  Processor {
        return { (assets) in
            let queue = OperationQueue()
            var objects:[ProcessAsset] = []
            let blocks = assets.map { (image) -> BlockOperation in
                return BlockOperation {
                    do {
                        let object = try preformOn(image)
                        objects.append(object)
                    }catch {
                        //TODO: handle error
                    }
                }
            }
            queue.addOperations(blocks, waitUntilFinished: true)
            return objects
        }
    }
    
    
    static func stackProcessor<T>(_ stack: Stack<[PHAsset]>, processor:@escaping ([ProcessAsset]) throws -> [T]) -> [T] {
        var stack = stack
        var objects:[T] = []
        while !stack.isEmpty() {
            let startDate = Date()
            if let asssts = stack.pop() {
                do {
                    let detectObjects = try asssts.processAsset() |> processor
                    objects.append(contentsOf: detectObjects)
                }catch {   }
            }
            print("finish round in: \(startDate.timeIntervalSinceNow * -1) sconed")
        }
        return objects
    }
    
    static func createStackProcessor(processor:@escaping Processor) -> StackProcessor {
        return { (stack) in
            var stack = stack
            var objects:[ProcessAsset] = []
            while !stack.isEmpty() {
                if let asssts = stack.pop() {
                    do {
                        let detectObjects = try asssts.processAsset() |> processor
                        objects.append(contentsOf: detectObjects)
                    }catch {   }
                }
            }
            return objects
        }
        

    }

}
