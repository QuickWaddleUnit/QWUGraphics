//
//  Protocols.swift
//  QWUGraphics
//
//  Created by Emilio Espinosa on 5/20/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation

public protocol QWUVisible {
    var back: QWUColor { get }
    var visible: Bool { get set }
    var selectable: Bool { get set }
    var rect: CGRect { get }
    
    func setRect(_ rect: CGRect)
    func drawBackground()
    func drawRect()
}

public protocol QWUMouseResponder {
    var leftClick: (() -> ())?              { get set }
    var middleClick: (() -> ())?            { get set }
    var rightClick: (() -> ())?             { get set }
    var leftClickRelease: (() -> ())?       { get set }
    var middleClickRelease: (() -> ())?     { get set }
    var rightClickRelease: (() -> ())?      { get set }
}