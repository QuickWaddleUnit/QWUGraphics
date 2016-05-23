//
//  QWUWindow.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

// QWUWidget class
// Description:
// Base class for windows. Contains the xlib ID number and all cairo necessary objects
// in order to perform all the drawing functions required for its widgets.
// Conforms to: QWUVisible, QWUMouseResponder

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
    
    public init(screen: Int32 = QWUApplication.defaultScreen(), background: QWUColor = QWUColor.white, rect r: CGRect) {
        
        let dsp = QWUApplication.display!
        
        // Initialize XWindow
        winID = XCreateWindow(dsp, XDefaultRootWindow(dsp), Int32(r.origin.x), Int32(r.origin.y), UInt32(r.size.width), UInt32(r.size.height), 0, 0, UInt32(CopyFromParent), XDefaultVisual(dsp, screen), 0, nil)
        XSelectInput(dsp, winID, ButtonPressMask | ButtonReleaseMask | KeyPressMask | KeyReleaseMask | ExposureMask | StructureNotifyMask | FocusChangeMask | KeymapStateMask)
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
    
    deinit {
        if !destroyed {
            destroy()
        }
    }
    
    // Name: destroy()
    // No parameters
    // Description: Releases all its resources and destroys the xlib window.
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
    
    // Name: rectChangeEvent()
    // 1 parameter
    // (_ r: CGRect) - New rect given from the resize event
    // Description: Sets the new rect as its own and fixes the size of the cairo surface.
    internal func rectChangeEvent(_ r: CGRect) {
        rect = r
        surface.setSize(rect.size)
    }
    
    // Name: setRect()
    // 1 parameter
    // (_ r: CGRect) - Rect to become the new size and position of the window
    // Description: Moves and Resizes the window to the specified rect.
    public func setRect(_ r: CGRect) {
        rect = r
        XMoveResizeWindow(QWUApplication.display, winID, Int32(r.origin.x), Int32(r.origin.y), UInt32(r.size.width), UInt32(r.size.height))
        surface.setSize(rect.size)
    }
    
    // MARK: Click Events
    public var leftClick: (() -> ())?
    public var rightClick: (() -> ())?
    public var middleClick: (() -> ())?
    public var leftClickRelease: (() -> ())?
    public var rightClickRelease: (() -> ())?
    public var middleClickRelease: (() -> ())?
    
    // Name: click()
    // 2 parameters
    // (button: MouseButton) - Mouse button that was clicked
    // (atPos: CGPoint) - Position of mouse click
    // Description: Handles the mouse click event depending on the appropriate
    // function attached to each mouse event, if any.
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
            middleClick?()
            print("Middle click")
        case .WheelUp:
            print("Wheel Up")
        case .WheelDown:
            print("Wheel Down")
        }
    }
    
    // Name: drawBackground()
    // No parameters
    // Description: This function will draw the background for the window.
    public func drawBackground() {
        context.setSourceColor(back)
        context.paint()
    }
    
    // Name: drawRect()
    // No parameters
    // Description: Draws the window and all of its contined widgets.
    public func drawRect() {
        
    }
    
    // Name: show()
    // No parameter
    // Description: Maps the window to the display to have it appear on the screen. Do
    // no use this function directly, use the visible property instead.
    internal func show() {
        let dsp = QWUApplication.display
        let pos = rect.origin.toIntRep()
        XMapWindow(dsp, winID)
        XMoveWindow(dsp, winID, pos.0, pos.1)
    }
    
    // Name: hide()
    // No parameter
    // Description: Unmaps the window to the display to have it disappear from the screen. Do
    // no use this function directly, use the visible property instead.
    internal func hide() {
        XUnmapWindow(QWUApplication.display, winID)
    }
    
    // Name: keyEvent()
    // 1 parameter
    // (buffer: String) - Buffer supplied from the main loop key events
    // Description: Decode the buffer to be used by the window or be forwarded to a contained.
    // widget
    public func keyEvent(buffer: String) {
        // TODO: Do stuff with key
    }
}
