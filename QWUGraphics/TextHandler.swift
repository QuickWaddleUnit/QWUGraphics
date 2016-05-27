//
//  TextHandler.swift
//  QWUGraphics
//
//  Created by Mikey Salinas on 5/27/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation

protocol TextHandler: InputHandler {
    
    func textEditingBegan(input: Character)
    func textEditingChanged(input: Character)
    func textEditingEnded(input: Character)
}

extension TextHandler {
    
    func handleEvent(event: QWUEvent) {
        if event.type != .Keyboard { return }
        
        textEditingChanged(input: event.characterValue)
    }
}