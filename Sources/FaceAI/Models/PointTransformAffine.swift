//
//  File.swift
//  
//
//  Created by Amir Lahav on 13/02/2021.
//

import simd
import UIKit

class PointTransformAffine {
    var m: simd_double2x2
    var b: simd_double2
    
    init(m: simd_double2x2, b: simd_double2) {
        self.m = m
        self.b = b
    }
    
    func makeTransform() -> CGAffineTransform {
        CGAffineTransform(a: CGFloat(m.columns.0.x), b: CGFloat(m.columns.1.x),
                          c: CGFloat(m.columns.0.y), d: CGFloat(m.columns.1.y),
                          tx: CGFloat(b.x), ty: CGFloat(b.y))
    }
    
    func applyTransform(_ point: simd_double2) -> simd_double2 {
        let r = m * point + b
        return simd_double2(r.x, r.y)
    }
}
