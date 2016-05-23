//
//  QWUWidget.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

// QWUWidget class
// Description:
// Base class for all widgets that will be created.

public class QWUWidget {
    public var name: String = ""
    public var parentWidget: QWUWidget?
    public var focus = false
    internal var destroyed = false
    
    // Name: destroy()
    // No parameters
    // Description: Base destroy function which marks a widget as being destroyed.
    public func destroy() {
        destroyed = true
    }
}