//
//  File.swift
//  
//
//  Created by Amir Lahav on 13/02/2021.
//

import simd
import UIKit

extension SIMD2 where Scalar == Double {
    func apply(_ tranform: CGAffineTransform) -> simd_double2 {
        let point = CGPoint(x: self.x, y: self.x)
        point.applying(tranform)
        return simd_double2(Double(point.x), Double(point.y))
    }
    
    var length: Double {
        sqrt(pow(x, 2) + pow(y, 2))
    }
}

extension simd_double2 {
    func toPoint() -> CGPoint {
        CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
