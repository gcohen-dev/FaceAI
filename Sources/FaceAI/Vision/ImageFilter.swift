//
//  ImageAnalyzer.swift
//
//  Created by amir.lahav on 10/11/2019.
//  Copyright © 2019 la-labs. All rights reserved.
//

import Foundation
import Vision
import CoreML
import UIKit

typealias VisionFilter = (ProcessAsset) throws -> ProcessAsset
typealias CustomFilter<T> = (CustomProcessAsset) throws -> T


class ImageFilter {
    
    func filter(type: VisionProcessType) -> VisionFilter {
        switch type {
        case .faceDetection:
            return detectFaces
        case .objectDetection:
            return tagPhoto
        case .imageQuality:
            return imageQuality
        case .imageFatching:
            return fetchAsset
        case .cluster:
            return featureDetection |>> embbedFaces
        }
    }
    
    /// Detect bounding box around faces in image
    ///
    /// - Parameter asset: User image
    ///
    /// - Returns: ImageObservation struct include vision bounding rect, original image, and image size
    private func detectFaces(asset: ProcessAsset) throws -> ProcessAsset {
        return try autoreleasepool { () -> ProcessAsset in
            let requestHandler = VNImageRequestHandler(cgImage: (asset.image.cgImage!), options: [:])
            let request = VNDetectFaceRectanglesRequest()
            try requestHandler.perform([request])
            guard let observations = request.results as? [VNFaceObservation] else {
                throw VisionProcessError.facesDetcting
            }
//            let url = SharedResource.faceModelURL

    //            guard !observations.isEmpty else {
//                throw FaceClustaringError.emptyObservation
//            }
            return ProcessAsset(identifier: asset.identifier,
                                image: asset.image, tags: asset.tags,
                                faceQuality: asset.faceQuality,
                                observation: mapBoundignBoxToRects(observation: observations),
                                faces: [])
        }
    }

    private func fetchAsset(asset: ProcessAsset) throws -> ProcessAsset {
        return autoreleasepool { () -> ProcessAsset in
        let imageFetcher = ImageFetcherService()
        if let image = imageFetcher.image(from: asset.identifier) {
            return ProcessAsset(identifier: asset.identifier,
                                image: image, tags: [],
                                faceQuality: 0,
                                observation: [],
                                faces: [])
        }
            return ProcessAsset(identifier: asset.identifier, image: UIImage(), tags: [], faceQuality: 0, observation: [], faces: [])
        }
    }
    
    private func featureDetection(asset: ProcessAsset) throws -> ProcessAsset {
        return try autoreleasepool { () -> ProcessAsset in
            let requestHandler = VNImageRequestHandler(cgImage: (asset.image.cgImage!), options: [:])
            
            let request = VNDetectFaceLandmarksRequest()
            try requestHandler.perform([request])
            guard let observations = request.results as? [VNFaceObservation] else {
                throw VisionProcessError.facesDetcting
            }
            let faces = observations.map { (observation) -> Face in
                Face(localIdnetifier: asset.identifier, faceID: "", faceCroppedImage: UIImage(), meanEmbedded: [], faceFeatures: observation, quality: 0)
            }
            return ProcessAsset(identifier: asset.identifier,
                                image: asset.image,
                                tags: asset.tags,
                                faceQuality: asset.faceQuality,
                                observation: mapBoundignBoxToRects(observation: observations),
                                faces: faces)
        }
    }
    
    private func embbedFaces(asset: ProcessAsset) throws -> ProcessAsset {
        return try autoreleasepool { () -> ProcessAsset in
            let url = Bundle.module.url(forResource: "facenet_keras_weights_coreml", withExtension: ".mlmodelc")
            let model = try facenet_keras_weights_coreml(contentsOf: url!, configuration: MLModelConfiguration()).model
            let request = VNCoreMLRequest(model: try VNCoreMLModel(for: model))
            var faces = asset.faces.map({extractChip(face: $0, image: asset.image)})
            faces = try faces.map({ (face) -> Face in
                let MLRequestHandler = VNImageRequestHandler(cgImage: face.faceCroppedImage.cgImage!, options: [:])
                try MLRequestHandler.perform([request])
                return genEmbeddingsHandler(face: face, request: request)
            })
            return ProcessAsset(identifier: asset.identifier,
                                image: asset.image,
                                tags: asset.tags,
                                faceQuality: asset.faceQuality,
                                observation: asset.observation,
                                faces: faces)
        }
    }
    
    private func imageQuality(asset: ProcessAsset) throws -> ProcessAsset {
        return try autoreleasepool { () -> ProcessAsset in
            let requestHandler = VNImageRequestHandler(cgImage: (asset.image.cgImage!), options: [:])
            let request = VNDetectFaceCaptureQualityRequest()
            try requestHandler.perform([request])
//            guard let observation = request.results?.first as? VNFaceObservation else {
//                throw FaceClustaringError.facesDetcting
//            }
            return ProcessAsset(identifier: asset.identifier,
                                image: asset.image,
                                tags: asset.tags,
                                faceQuality: (request.results?.first as? VNFaceObservation)?.faceCaptureQuality ?? 0,
                                observation: asset.observation,
                                faces: [])
        }
    }
    
    private func tagPhoto(asset: ProcessAsset) throws -> ProcessAsset {
        return try autoreleasepool { () -> ProcessAsset in
            let requestHandler = VNImageRequestHandler(cgImage: (asset.image.cgImage!), options: [:])
            let request = VNClassifyImageRequest()
            try requestHandler.perform([request])
            var categories: [String] = []

            if let observations = request.results as? [VNClassificationObservation] {
                categories = observations
                    .filter { $0.hasMinimumRecall(0.01, forPrecision: 0.9) }
                    .reduce(into: [String]()) { arr, observation in arr.append(observation.identifier)  }
            }
            
            return ProcessAsset(identifier: asset.identifier,
                                image: asset.image,
                                tags: categories,
                                faceQuality: asset.faceQuality,
                                observation: asset.observation,
                                faces: [])
        }
    }
    
    func custom<T>(model: MLModel) -> CustomFilter<T> {
        return { asset in
            return try autoreleasepool { () -> T in
                guard let model = try? VNCoreMLModel(for: model) else {
                    throw VisionProcessError.unknown
                }
                let request =  VNCoreMLRequest(model:model)
                request.imageCropAndScaleOption = .centerCrop
                let requestHandler = VNImageRequestHandler(cgImage: (asset.image.cgImage!), options: [:])
                try requestHandler.perform([request])
                guard let results = request.results as? T else {
                    throw VisionProcessError.unknown
                }
                return results
            }
        }
    }
    
    private func mapBoundignBoxToRects(observation: [VNFaceObservation]) -> [CGRect] {
        observation.map(convertRect)
    }
    
    private func convertRect(face: VNFaceObservation) -> CGRect {
        return face.boundingBox
    }
    
    private func genEmbeddingsHandler(face: Face, request: VNRequest) -> Face {
        guard let observations = request.results as? [ VNCoreMLFeatureValueObservation] , let firstObserve = observations.first,
            let emb = firstObserve.featureValue.multiArrayValue else {
            return face
        }
        let embbeded = buffer2Array(length: emb.count, data: emb.dataPointer, Double.self) |> norm_l2
        return Face(localIdnetifier: face.localIdnetifier, faceID: face.faceID, faceCroppedImage: face.faceCroppedImage, meanEmbedded: embbeded, faceFeatures: face.faceFeatures, quality: face.quality)
    }
    
    private func buffer2Array<T>(length: Int, data: UnsafeMutableRawPointer, _: T.Type) -> [T] {
        let ptr = data.bindMemory(to: T.self, capacity: length)
        let buffer = UnsafeBufferPointer(start: ptr, count: length)
        return Array(buffer)
    }
    
    private func norm_l2(emb: [Double]) -> [Double] {
        let sum: Double = emb.reduce(0) { (result, next) in
            return result + next * next
        }
        let emb: [Double] = emb.compactMap({ return $0/sqrt(sum) })
        return emb
    }
    
    func extractChip(face: Face, image: UIImage) -> Face {
        let chipImage = Interpulation.extractImageChip(image, chipDetail: Interpulation.getFaceChipDetails(det: face.faceFeatures, imageSize: image.size, size: 160, padding: 0.4), observation: face.faceFeatures) ?? UIImage()
        return Face(localIdnetifier: face.localIdnetifier,
             faceID: face.faceID,
             faceCroppedImage: chipImage,
             meanEmbedded: face.meanEmbedded,
             faceFeatures: face.faceFeatures,
             quality: face.quality)
    }
}
