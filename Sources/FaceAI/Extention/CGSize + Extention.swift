//
//  File.swift
//  
//
//  Created by Amir Lahav on 17/02/2021.
//

import UIKit

extension CGSize {
    func scale(imageSize: CGSize) -> CGSize {
        CGSize(width: width * imageSize.width, height: height * imageSize.height)
    }
    
    var area: CGFloat {
        width * height
    }
}
