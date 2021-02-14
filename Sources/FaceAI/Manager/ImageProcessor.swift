//
//  ImageProcessor.swift
//
//  Created by amir.lahav on 16/11/2019.
//  Copyright © 2019 la-labs. All rights reserved.
//

import Foundation
import Photos

typealias SinglePipe<Input,Output> = (Input) throws -> Output
typealias MultiplePipe<Input,Output> = ([Input]) throws -> [Output]
typealias GenericStackProcessor<Input,Output> = (Stack<[Input]>) throws -> [Output]

typealias Processor = ([ProcessAsset]) throws -> [ProcessAsset]
typealias StackProcessor = (Stack<[ProcessAsset]>) throws -> [ProcessAsset]

class ImageProcessor {
        
    /// Create opertion queue to process all assets.
    /// - Return analized objects
    /// - Parameter images: User Images
    static func multipleProcessor<Input, Output>(inputs: [Input], preformOn: @escaping (Input) throws -> [Output]) ->  [Output] {
        let queue = OperationQueue()
        var objects: [Output] = []
        let blocks = inputs.map { (input) -> BlockOperation in
            return BlockOperation {
                do {
                    let processedObject = try preformOn(input)
                    objects.append(contentsOf: processedObject)
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
    static func singleProcessor<Input, Output>(element: [Input],
                                               preformOn: @escaping SinglePipe<Input,Output>) ->  [Output] {
        let queue = OperationQueue()
        var objects: [Output] = []
        let blocks = element.map { (image) -> BlockOperation in
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
    static func makeSingleProcessProcessor<Input, Output>(preformOn: @escaping SinglePipe<Input,Output>) -> MultiplePipe<Input, Output> {
        return { (element) in
            return singleProcessor(element: element, preformOn: preformOn)
        }
    }
    
    
    static func stackProcessor<Input, Output>(_ stack: Stack<[Input]>, processor: @escaping MultiplePipe<Input,Output>) -> [Output] {
        var stack = stack
        var objects: [Output] = []
        while !stack.isEmpty() {
            let startDate = Date()
            if let asssts = stack.pop() {
                do {
                    let detectObjects = try processor(asssts)
                    objects.append(contentsOf: detectObjects)
                }catch {   }
            }
            print("finish round in: \(startDate.timeIntervalSinceNow * -1) sconed")
        }
        return objects
    }
    
    static func makeStackProcessor<Input, Output>(processor: @escaping MultiplePipe<Input, Output>) -> GenericStackProcessor<Input, Output> {
        return { (stack) in
            return stackProcessor(stack, processor: processor)
        }
    }
}
