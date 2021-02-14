//
//  File.swift
//  
//
//  Created by Amir Lahav on 13/02/2021.
//

import UIKit
import simd

extension CGPoint {
    func toVector() -> simd_double2 {
        simd_double2(Double(x), Double(y))
    }
    
    static func /(_ rhs: CGPoint, magnitude: CGFloat) -> CGPoint {
        CGPoint(x: rhs.x/magnitude, y: rhs.y/magnitude)
    }
    
    static func +(_ rhs: CGPoint, magnitude: CGFloat) -> CGPoint {
        CGPoint(x: rhs.x + magnitude, y: rhs.y + magnitude)
    }
}
