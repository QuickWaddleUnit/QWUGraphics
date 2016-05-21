//
//  main.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation

func setup() {
    let w: QWUWindow = QWUWindow()
    let w2: QWUWindow = QWUWindow(x: 200, y: 100, width: 100, height: 200, background: QWUColor.blue)
    QWUApplication.addWindow(win: w)
    QWUApplication.addWindow(win: w2)
    w.visible = true
    w2.show()
}

setup()
QWUApplication.run()
