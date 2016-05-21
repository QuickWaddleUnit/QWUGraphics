//
//  QWUWidget.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

public class QWUWidget {
    public var name: String = ""
    public var parentWidget: QWUWidget?
    public var focus = false
    internal var destroyed = false
    
    public func destroy() {
        destroyed = true
    }
}