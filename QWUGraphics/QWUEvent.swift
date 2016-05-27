//
//  QWUEvent.swift
//  QWUGraphics
//
//  Created by Mikey Salinas on 5/27/16.
//  Copyright © 2016 Emilio Espinosa. All rights reserved.
//

import Foundation

struct QWUEvent {
    var type: EventType = .Keyboard
    var characterValue: Character
    
    init(type: EventType, characterValue: Character){
        self.type = type
        self.characterValue = characterValue
    }
}

enum EventType {
    case Keyboard
    case Mouse
    case Remote
}