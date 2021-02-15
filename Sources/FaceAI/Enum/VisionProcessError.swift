//
//  VisionProcessError.swift
//  
//
//  Created by Amir Lahav on 29/01/2021.
//

import Foundation

public enum VisionProcessError: Error {
    
    case unknown
    case fetchImages
    case facesDetcting
    case cgImageNotFound
    case emptyObservation
    case error(Error)
    var description: String {
        switch self {
        case .fetchImages:
            return "Cannot fetch this image"
        case .facesDetcting:
            return "Unable to detect faces"
        case .cgImageNotFound:
            return "CGImage not found"
        case .emptyObservation:
            return "No faces found"
        case .unknown:
            return "Unknown error"
        case .error(let error):
        return error.localizedDescription
        }
    }
}
