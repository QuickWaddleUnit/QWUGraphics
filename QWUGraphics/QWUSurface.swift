//
//  Surface.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/12/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

// QWUSurface class
// Description:
// This class will be used to hold the pointer to the cairo surface used by the xlib windows.

public class QWUSurface {
    var sfc: OpaquePointer
    
    init(display: UnsafeMutablePointer<Display>, drawable: Drawable, visual: UnsafeMutablePointer<Visual>, size: CGSize) {
        let intSize = size.toIntRep()
        sfc = cairo_xlib_surface_create(display, drawable, visual, intSize.0, intSize.1)
    }
    
    init(other: QWUSurface, content: Content, size: CGSize) {
        sfc = cairo_surface_create_similar(other.sfc, cairo_content_t(rawValue: content.rawValue), Int32(size.width), Int32(size.height))
    }
    
    init(other: QWUSurface, format: Format, size: CGSize) {
        sfc = cairo_surface_create_similar_image(other.sfc, cairo_format_t(rawValue: format.rawValue), Int32(size.width), Int32(size.height))
    }
    
    init(target: QWUSurface, rect: CGRect) {
        sfc = cairo_surface_create_for_rectangle(target.sfc, Double(rect.origin.x), Double(rect.origin.y), Double(rect.size.width), Double(rect.size.height))
    }
    
    func destroy() {
        cairo_surface_destroy(sfc)
    }
    
    func status() -> Status {
        return Status(rawValue: cairo_surface_status(sfc).rawValue)!
    }
    
    func finish() {
        cairo_surface_finish(sfc)
    }
    
    func flush() {
        cairo_surface_flush(sfc)
    }
    
    func getContent() -> Content {
        return Content(rawValue: cairo_surface_get_content(sfc).rawValue)!
    }
    
    func setSize(_ size: CGSize) {
        let intSize = size.toIntRep()
        cairo_xlib_surface_set_size(sfc, intSize.0, intSize.1)
    }
    
    func getScreen() -> UnsafeMutablePointer<Screen> {
        return cairo_xlib_surface_get_screen(sfc)
    }
}