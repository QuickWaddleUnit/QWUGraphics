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
    internal var rect = CGRect.zero
    internal var visible = false
    
    public func destroy() {}
    
    public var leftClick: (() -> ())?
    public var middleClick: (() -> ())?
    public var rightClick: (() -> ())?
    public var leftClickRelease: (() -> ())?
    public var middleClickRelease: (() -> ())?
    public var rightClickRelease: (() -> ())?
}
