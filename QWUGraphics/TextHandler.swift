//
//  TextHandler.swift
//  QWUGraphics
//
//  Created by Mikey Salinas on 5/27/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation

protocol TextHandler: InputHandler {
    func textEditingBegan(input: String)
    func textEditingChanged(input: String)
    func textEditingEnded(input: String)
}

extension TextHandler {
    
}