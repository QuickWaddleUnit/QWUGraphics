//
//  main.swift
//  QWUI
//
//  Created by Emilio Espinosa on 5/10/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

func run() {
    var w: QWUWindow? = QWUWindow(x: 0, y: 0, width: 300, height: 200)
    var w2: QWUWindow? = QWUWindow(x: 200, y: 100, width: 100, height: 200)
    QWUApplication.addWindow(win: w!)
    QWUApplication.addWindow(win: w2!)
    w!.show()
    w2!.show()
    w = nil
    w2 = nil
    QWUApplication.run()
}

run()

