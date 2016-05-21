//
//  QWUWindow.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

public class QWUWindow: QWUContainer, QWUVisible, QWUMouseResponder {
    private var surface: QWUSurface
    private(set) var context: QWUContext
    private(set) var winID: Window
    private(set) public var back: QWUColor
    internal(set) public var rect: CGRect
    public var selectable: Bool
    public var visible: Bool {
        didSet {
            if visible {
                show()
            } else {
                hide()
            }
        }
    }
    
    deinit {
        if !destroyed {
            destroy()
        }
    }
    
    public init(screen: Int32 = QWUApplication.defaultScreen(), background: QWUColor = QWUColor.white, rect r: CGRect) {
        
        let dsp = QWUApplication.display!
        
        // Initialize XWindow
        winID = XCreateWindow(dsp, XDefaultRootWindow(dsp), Int32(r.origin.x), Int32(r.origin.y), UInt32(r.size.width), UInt32(r.size.height), 0, 0, UInt32(CopyFromParent), XDefaultVisual(dsp, screen), 0, nil)
        XSelectInput(dsp, winID, ButtonPressMask | KeyPressMask | KeyReleaseMask | ExposureMask | StructureNotifyMask | FocusChangeMask | KeymapStateMask)
        var wmDeleteMessage = XInternAtom(dsp, "WM_DELETE_WINDOW", False)
        XSetWMProtocols(dsp, winID, &wmDeleteMessage, 1)
        back = background
        selectable = true
        
        // Setup Cairo surface and context
        surface = QWUSurface(display: dsp, drawable: winID, visual: XDefaultVisual(dsp, screen), size: r.size)
        context = QWUContext(target: surface)
        
        visible = false
    
        // Set Rect
        rect = r
    }
    
    public convenience override init() {
        self.init(rect: CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    public convenience init(position: CGPoint, size: CGSize, background: QWUColor = QWUColor.white) {
        self.init(background: background, rect: CGRect(origin: position, size: size))
    }
    
    public convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, background: QWUColor = QWUColor.white) {
        self.init(background: background, rect: CGRect(x: x, y: y, width: width, height: height))
    }
    
    public override func destroy() {
        super.destroy()
        leftClick = nil
        rightClick = nil
        middleClick = nil
        leftClickRelease = nil
        rightClickRelease = nil
        middleClickRelease = nil
        context.destroy()
        surface.destroy()
        XDestroyWindow(QWUApplication.display, winID)
    }
    
    internal func rectChangeEvent(_ r: CGRect) {
        rect = r
        surface.setSize(rect.size)
    }
    
    public func setRect(_ r: CGRect) {
        rect = r
        XMoveResizeWindow(QWUApplication.display, winID, Int32(r.origin.x), Int32(r.origin.y), UInt32(r.size.width), UInt32(r.size.height))
        surface.setSize(rect.size)
    }
    
    public var leftClick: (() -> ())?
    public var rightClick: (() -> ())?
    public var middleClick: (() -> ())?
    public var leftClickRelease: (() -> ())?
    public var rightClickRelease: (() -> ())?
    public var middleClickRelease: (() -> ())?
    
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
        case .WheelDown:
            print("Wheel Down")
        }
    }
    
    // This function will draw the background for the window
    public func drawBackground() {
        context.setSourceColor(back)
        context.paint()
    }
    
    public func drawRect() {
        
    }
    
    public func show() {
        let dsp = QWUApplication.display
        let pos = rect.origin.toIntRep()
        XMapWindow(dsp, winID)
        XMoveWindow(dsp, winID, pos.0, pos.1)
    }
    
    public func hide() {
        XUnmapWindow(QWUApplication.display, winID)
    }
    
    public func keyEvent(buffer: String) {
        // TODO: Do stuff with key
    }
}
