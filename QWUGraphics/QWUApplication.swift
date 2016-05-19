//
//  QWUApplication.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation
import XMod

public class QWUApplication {
    internal static let display = XOpenDisplay(nil)
    private static var windows = [UInt: QWUWindow]()
    internal static var activeWindow: QWUWindow? = nil
    
    static func screenCount() -> Int {
        return Int(XScreenCount(display))
    }
    
    static func defaultScreen() -> Int32 {
        assert(display != nil, "Display has not been initialized!")
        return XDefaultScreen(display)
    }
    
    static func addWindow(win: QWUWindow) {
        windows[win.winID] = win
    }
    
    static func removeWindow(win: QWUWindow) {
        windows.removeValue(forKey: win.winID)
    }
    
    static func getWindows() -> [UInt: QWUWindow] {
        return windows
    }
    
    static func getActiveWindow() -> QWUWindow? {
        return activeWindow
    }
    
    static func run() {
        startTimer()
        
        let loop = NSRunLoop.current()
        while !stopLoop && loop.run(mode: NSDefaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.005)) {}
        
        XCloseDisplay(display)
    }
    
    private static func runningLoop() {
        checkEvent()
    }
    
    static var stopLoop = false
    static var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
    static var queue = dispatch_queue_create("myTimer", nil)
    static func startTimer() {
//        TODO: Uncomment and use for Linux
//        let config = XRRGetScreenInfo(display, XRootWindow(display, defaultScreen()))
//        let refreshRate = XRRConfigCurrentRate(config)
//        var a = UInt64((1.0 / refreshRate) * 1000000000)
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
    
    static func stopTimer() {
        dispatch_source_cancel(timer!)
        timer = nil
        stopLoop = true
    }
    
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
                print(key)
                print(XKeysymToKeycode(display, key))
                print(String(cString: XKeysymToString(key), encoding: NSUTF8StringEncoding))
                
                // TODO: Figure out what the cuss to do here
                
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
                windows[event.window]?.draw()
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
                    win.setRect(eventRect)
                    win.drawBack()
                }
                win.draw()
                
            case FocusIn:
                let event = e.xfocus
                activeWindow = windows[event.window]!
                
            case FocusOut:
                activeWindow = nil
                
            case MapNotify:
                let event = e.xcreatewindow
                windows[event.window]?.drawBack()
                
            case ClientMessage:
                let event = e.xclient
                let win = windows[event.window]!
                if (UInt(event.data.l.0) == XInternAtom(display, "WM_DELETE_WINDOW", False)) {
                    QWUApplication.removeWindow(win: win)
                    win.destroy()
                }
            default:
                print("Dropping unhandled XEevent.type(\(e.type))")
            }
        }
    }
    
}
