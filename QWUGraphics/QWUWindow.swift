//
//  QWUWindow.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

public class QWUWindow: QWUContainer {
    private var surface: QWUSurface
    private var context: QWUContext
    private(set) var winID: Window
    private var back: QWUColor?
    var background = 1
    
    public init(screen: Int32 = QWUApplication.defaultScreen(), rect r: CGRect) {
        
        let dsp = QWUApplication.display!
        
        // Initialize XWindow
        winID = XCreateWindow(dsp, XDefaultRootWindow(dsp), Int32(r.origin.x), Int32(r.origin.y), UInt32(r.size.width), UInt32(r.size.height), 0, 0, UInt32(CopyFromParent), XDefaultVisual(dsp, screen), 0, nil)
        XSelectInput(dsp, winID, ButtonPressMask | KeyPressMask | KeyReleaseMask | ExposureMask | StructureNotifyMask | FocusChangeMask | KeymapStateMask)
        var wmDeleteMessage = XInternAtom(dsp, "WM_DELETE_WINDOW", False)
        XSetWMProtocols(dsp, winID, &wmDeleteMessage, 1)
        
        // Setup Cairo srface and context
        surface = QWUSurface(display: dsp, drawable: winID, visual: XDefaultVisual(dsp, screen), size: r.size)
        context = QWUContext(target: surface)
        
        super.init()
        // Set Rect
        rect = r
    }
    
    public convenience init(position: CGPoint, size: CGSize) {
        self.init(rect: CGRect(origin: position, size: size))
    }
    
    public convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(rect: CGRect(x: x, y: y, width: width, height: height))
    }
    
    public override func destroy() {
        context.destroy()
        surface.destroy()
        XDestroyWindow(QWUApplication.display, winID)
    }
    
    internal func setRect(_ r: CGRect) {
        rect = r
        surface.setSize(rect.size)
    }
    
    internal func click(button: MouseButton, atPos: CGPoint) {
        // TODO: Check contained widgets
        switch button {
        case .Left:
            leftClick?()
            print("Left click")
        case .Right:
            rightClick?()
            print("Right click")
        case .Middle:
            print("Middle click")
        case .WheelUp:
            print("Wheel Up")
        default:
            print("Undefined Button")
        }
    }
    
    // This function will draw the background for the window
    func drawBack(color: QWUColor = QWUColor.green) {
        context.setSourceColor(color)
        context.paint()
    }
    
    func draw() {
        
    }
    
    public func show() {
        visible = true
        let dsp = QWUApplication.display
        let pos = rect.origin.toIntRep()
        XMapWindow(dsp, winID)
        XMoveWindow(dsp, winID, pos.0, pos.1)
    }
    
    public func hide() {
        visible = false
        XUnmapWindow(QWUApplication.display, winID)
    }
    
    public func keyEvent(buffer: String) {
        // TODO: Do stuff with key
    }
}
