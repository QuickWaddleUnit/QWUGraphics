//
//  QWUContainer.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

// QWUContainer class
// Description:
// Base class for all container widgets. Acts as a container for widgets and will be
// able to align them into position

public class QWUContainer: QWUWidget {
    // MARK: Properties
    private var widgets = [QWUWidget]()
    
    // Name: addWidget()
    // 1 parameter
    // (wid: QWUWidget) - Widget that will be added to the container
    // Description: Adds a widget to the container and sets self as its parent.
    public func addWidget(wid: QWUWidget) {
        widgets.append(wid)
        wid.parentWidget = self
    }
    
    // Name: removeWidget()
    // 1 parameter
    // (wid: QWUWidget) - Widget that needs to be removed from the container
    // Description: Removes the desired widget from the container if found.
    public func removeWidget(wid: QWUWidget) {
        if let index = widgets.index(where: {$0 === wid}) {
            widgets.remove(at: index)
            wid.parentWidget = nil
        }
    }
    
    // Name: widgetAt()
    // 1 parameter
    // (_ pos: CGPoint) - Point that might be contained inside a widget
    // Description: Searches for a widget that contains the point supplied; the widget
    // must be visible.
    // Returns: QWUWidget?
    public func widgetAt(_ pos: CGPoint) -> QWUWidget? {
        for w in widgets {
            if let wid = w as? QWUVisible {
                if wid.rect.contains(pos) && wid.visible {
                    return w
                }
            }
        }
        return nil
    }
    
    // Name: destroy()
    // No parameters
    // Description: Removes and destroys all contained widgets.
    public override func destroy() {
        super.destroy()
        for wid in widgets {
            wid.destroy()
            wid.parentWidget = nil
        }
        widgets.removeAll()
    }
}