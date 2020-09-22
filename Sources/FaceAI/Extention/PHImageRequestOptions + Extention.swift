//
//  File.swift
//  
//
//  Created by amir.lahav on 21/09/2020.
//

import Foundation
import Photos

extension PHImageRequestOptions {
    
    static var defaultOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.version = .current
        return options
    }
    
    
}
