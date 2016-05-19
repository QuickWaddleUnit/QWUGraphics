//
//  Geometry.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/14/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation

extension CGPoint {
    func toIntRep() -> (Int32, Int32) {
        return (Int32(x), Int32(y))
    }
}

extension CGSize {
    func toIntRep() -> (Int32, Int32) {
        return (Int32(width), Int32(height))
    }
}

extension CGRect {
    func toIntRep() -> ((Int32, Int32), (Int32, Int32)) {
        return (origin.toIntRep(), size.toIntRep())
    }
}