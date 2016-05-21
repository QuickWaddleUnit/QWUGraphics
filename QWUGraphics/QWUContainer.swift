//
//  QWUContainer.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import XMod
import Foundation

public class QWUContainer: QWUWidget {
    private var widgets = [QWUWidget]()
    
    public func addWidget(wid: QWUWidget) {
        widgets.append(wid)
        wid.parentWidget = self
    }
    
    public func removeWidget(wid: QWUWidget) {
        if let index = widgets.index(where: {$0 === wid}) {
            widgets.remove(at: index)
            wid.parentWidget = nil
        }
    }
    
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
    
    public override func destroy() {
        super.destroy()
        for wid in widgets {
            wid.destroy()
        }
        widgets.removeAll()
    }
}