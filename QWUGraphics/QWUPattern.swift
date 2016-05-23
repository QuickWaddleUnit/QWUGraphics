//
//  Pattern.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/13/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

// QWUPattern class
// Description:
// Responsible for the main drawing operations or masks to be applied to the context. What this
// class holds will be what is actually drawn on the surface.

public class QWUPattern {
    
    var patternPtr: OpaquePointer
    
    deinit {
        cairo_pattern_destroy(patternPtr)
    }
    
    init(_ internalPointer: OpaquePointer) {
        patternPtr = internalPointer
    }
    
    convenience init(color: QWUColor) {
        let ptr = cairo_pattern_create_rgba(color.redVal, color.greenVal, color.blueVal, color.alpha)
        assert(ptr != nil, "Could not initiate pattern")
        self.init(ptr!)
    }
    
    convenience init(surface: QWUSurface) {
        let ptr = cairo_pattern_create_for_surface(surface.sfc)
        assert(ptr != nil, "Could not initiate pattern")
        self.init(ptr!)
    }
    
    convenience init(startPoint: CGPoint, endPoint: CGPoint) {
        let ptr = cairo_pattern_create_linear(Double(startPoint.x), Double(startPoint.y), Double(endPoint.x), Double(endPoint.y))
        assert(ptr != nil, "Could not initiate pattern")
        self.init(ptr!)
    }
    
    func getRGBA() -> QWUColor? {
        var color = QWUColor(red: 0, green: 0, blue: 0)
        if  Status(rawValue: cairo_pattern_get_rgba(patternPtr, &color.redVal, &color.greenVal, &color.blueVal, &color.alpha).rawValue) == .Success {
            return color
        }
        return nil
    }
    
    func getLinearPoints() {
        
    }
}
