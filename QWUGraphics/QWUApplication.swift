//
//  QWUApplication.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation
import XMod

// QWUApplication class
// Description:
// Responsible for maintaining the status of all the operations within an application. This includes
// handling input sources and keeping track of all created windows.

public class QWUApplication {
    // MARK: Static variables
    internal static let display = XOpenDisplay(nil)
    private static var windows = [UInt: QWUWindow]()
    internal static var activeWindow: QWUWindow? = nil
    
    // Event Handlers
    private static var eventHandlers: [InputHandler]?
    
    // MARK: Xlib Functions
    // Name: screenCount()
    // No parameters
    // Description: Returns the number of screens associated with the current display.
    static func screenCount() -> Int {
        return Int(XScreenCount(display))
    }
    
    // Name: defaultScreen()
    // No parameters
    // Description: Returns the default screen identifier for the current display.
    static func defaultScreen() -> Int32 {
        assert(display != nil, "Display has not been initialized!")
        return XDefaultScreen(display)
    }
    
    // MARK: Window Management Functions
    // addWindow()
    // 1 parameter
    // (win: QWUWindow) - Window that needs to be added to list
    // Description: Adds the supplied window to the application.
    static func addWindow(win: QWUWindow) {
        windows[win.winID] = win
    }
    
    // Name: removeWindow()
    // 1 parameter
    // (win: QWUWindow) - Window to remove from application
    // Description: Removes the window from the application.
    static func removeWindow(win: QWUWindow) {
        windows.removeValue(forKey: win.winID)
    }
    
    // Name: getWindows()
    // No parameters
    // Description: Returns a copy of the windows dictionary.
    static func getWindows() -> [UInt: QWUWindow] {
        return windows
    }
    
    // Name: getActiveWindow()
    // No parameters
    // Description: Returns the currently focused window(if any).
    static func getActiveWindow() -> QWUWindow? {
        return activeWindow
    }
    
    // MARK: - Running Loop
    // MARK: Run Loop Properties
    static var stopLoop = false
    static var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
    static var queue = dispatch_queue_create("myTimer", nil)
    
    // MARK: Run Loop Functions
    // Name: run()
    // No parameters
    // Description: Begins the main run loop of the application.
    static func run() {
        startTimer()
        
        let loop = NSRunLoop.current()
        while !stopLoop && loop.run(mode: NSDefaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.005)) {}
        
        XCloseDisplay(display)
    }
    
    // Name: runningLoop()
    // No parameters
    // Description: Set of functions to run every frame of the application.
    private static func runningLoop() {
        checkEvent()
    }
    
    // Name: startTimer()
    // No parameters
    // Description: Starts the timer to execute the run loop every frame as specified by the
    // display.
    private static func startTimer() {
//        TODO: Uncomment and use for Linux
//        let config = XRRGetScreenInfo(display, XRootWindow(display, defaultScreen()))
//        let refreshRate = XRRConfigCurrentRate(config)
//        var fps = UInt64((1.0 / refreshRate) * 1000000000)
        dispatch_source_set_timer(timer!, DISPATCH_TIME_NOW, 16666666, 16666666)
        dispatch_source_set_event_handler(timer!) {
            if windows.count > 0 {
                runningLoop()
            } else {
                stopTimer()
            }
        }
        dispatch_resume(timer!)
    }
    
    // Name: stopTimer()
    // No parameters
    // Description: Invalidates the run loop timer and stops the run loop.
    private static func stopTimer() {
        dispatch_source_cancel(timer!)
        timer = nil
        stopLoop = true
    }
    
    // Name: checkEvent()
    // No parameters
    // Description: Check the events of the xlib windows and flush the event queue. This includes
    // keyboard and mouse input, active window focus, and exposing a window.
    static func checkEvent() {
        var key: KeySym = KeySym()
        var e: XEvent = XEvent()
        while XPending(display) != 0 {
            XNextEvent(QWUApplication.display, &e)
            switch (e.type)
            {
            case ButtonPress:
                let event = e.xbutton
                let pos = CGPoint(x: Int(event.x), y: Int(event.y))
                if let button = MouseButton(rawValue: event.button) {
                    activeWindow?.click(button: button, atPos: pos)
                } else {
                    print("Unrecognized button click")
                }
            case ButtonRelease:
                print("Button Release")
            case KeyPress, KeyRelease:
                let keybuf = UnsafeMutablePointer<Int8>(allocatingCapacity: 20)
                XLookupString(&e.xkey, keybuf, 20, &key, nil)
                //print(key)
                //print(XKeysymToKeycode(display, key))
                // TODO: littleEndian might not work on all Linux machines! We should think about changing to Xcb instead of Xlib
                let keyUniVal = UnicodeScalar(Int(key.littleEndian))
                if keyUniVal.isASCII {
                    let charVal = Character.init(keyUniVal)
                    
                    let event = QWUEvent.init(type: .Keyboard, characterValue: charVal)
                    //Send key to event handlers
                    print(charVal)
                    guard let handlers = eventHandlers else {
                        break
                    }
                    for handler in handlers {
                        handler.handleEvent(event: event)
                    }
                }

                //print(String(cString: XKeysymToString(key), encoding: NSUTF8StringEncoding))
                
                // TODO: Figure out what to do here. Main keys functioning, need to decode special keys
                // like arrow keys, home, fn, etc.
                
    //                print(String(cString: keybuf))
    //                var s = String(cString: XKeysymToString(key))
    //                if s.characters.first == "U" && s.characters.count > 1 {
    //                    let hex = String(s.characters.dropFirst())
    //                    if let num = Int(hex, radix: 16) {
    //                        print(String(UnicodeScalar(num)))
    //                    }
    //                }
    //                let u = UnicodeScalar(0x25AA)
    //                print(Character(u))
                keybuf.deallocateCapacity(20)
            case KeymapNotify:
                XRefreshKeyboardMapping(&e.xmapping)
            case Expose:
                // TODO: Add clip to not redraw that which doesnt need to be
                let event = e.xexpose
                windows[event.window]?.drawRect()
            case ConfigureNotify:
                // TODO: On resize, clip background to draw faster
                let event = e.xconfigure
                let win = windows[event.window]!
                let intRect = win.rect.toIntRep()
                var eventRect = CGRect.zero
                let posDif = (event.x != intRect.0.0) || (event.y != intRect.0.1)
                let sizeDif = (event.width != intRect.1.0) || (event.height != intRect.1.1)
                if(posDif || sizeDif) {
                    eventRect.origin.x = CGFloat(event.x)
                    eventRect.origin.y = CGFloat(event.y)
                    eventRect.size.width = CGFloat(event.width)
                    eventRect.size.height = CGFloat(event.height)
                    win.rectChangeEvent(eventRect)
                    win.drawBackground()
                }
                win.drawRect()
                
            case FocusIn:
                let event = e.xfocus
                activeWindow = windows[event.window]!
                
            case FocusOut:
                activeWindow = nil
                
            case MapNotify:
                let event = e.xcreatewindow
                windows[event.window]?.drawBackground()
                
            case ClientMessage:
                let event = e.xclient
                let win = windows[event.window]!
                if (UInt(event.data.l.0) == XInternAtom(display, "WM_DELETE_WINDOW", False)) {
                    QWUApplication.removeWindow(win: win)
                    activeWindow = nil
                }
            default:
                print("Dropping unhandled XEevent.type(\(e.type))")
            }
        }
    }
    
}
