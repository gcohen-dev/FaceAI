//
//  File.swift
//  
//
//  Created by Amir Lahav on 13/02/2021.
//

import Foundation
import simd
import Accelerate

class LinearAlgebra {
    
    static func solveSystemOfEquations(matrix:[[Double]], vector:[Double])->[Double]{

        let flatMatrix = Array(matrix.joined())
        let laMatrix:la_object_t =
            la_matrix_from_double_buffer(flatMatrix,  la_count_t(matrix.count),  la_count_t(matrix[0].count),  la_count_t(matrix[0].count), la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let laVector = la_matrix_from_double_buffer(vector, la_count_t(vector.count), 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let vecCj = la_solve(laMatrix, laVector)
        var result: [Double] = Array(repeating: 0.0, count: matrix.count)
        let status = la_matrix_to_double_buffer(&result, 1, vecCj)

        if status == la_status_t(LA_SUCCESS) {
           return result
        } else {
           return [Double]()
        }
    }
    
    static func solveLeastSquare(A: [[Double]], B: [Double]) -> [Double]? {
        precondition(A.count == B.count, "Non-matching dimensions")
        var mode = Int8(bitPattern: UInt8(ascii: "N")) // "Normal" mode
        var nrows = CInt(A.count)
        var ncols = CInt(A[0].count)
        var nrhs = CInt(1)
        var ldb = max(nrows, ncols)

        // Flattened columns of matrix A
        var localA = (0 ..< nrows * ncols).map { (i) -> Double in
            A[Int(i % nrows)][Int(i / nrows)]
        }

        // Vector B, expanded by zeros if ncols > nrows
        var localB = B
        if ldb > nrows {
            localB.append(contentsOf: [Double](repeating: 0.0, count: Int(ldb - nrows)))
        }

        var wkopt = 0.0
        var lwork: CInt = -1
        var info: CInt = 0

        // First call to determine optimal workspace size
        var nrows_copy = nrows // Workaround for SE-0176
        dgels_(&mode, &nrows, &ncols, &nrhs, &localA, &nrows_copy, &localB, &ldb, &wkopt, &lwork, &info)
        lwork = Int32(wkopt)

        // Allocate workspace and do actual calculation
        var work = [Double](repeating: 0.0, count: Int(lwork))
        dgels_(&mode, &nrows, &ncols, &nrhs, &localA, &nrows_copy, &localB, &ldb, &work, &lwork, &info)

        if info != 0 {
            if Defaults.shared.print {
                print("A does not have full rank; the least squares solution could not be computed.")
            }
            return nil
        }
        return Array(localB.prefix(Int(ncols)))
    }
}
