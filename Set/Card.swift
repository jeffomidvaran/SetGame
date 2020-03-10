//
//  Card.swift
//  Set
//
//  Created by jeffomidvaran on 3/4/20.
//  Copyright © 2020 jeffomidvaran. All rights reserved.
//

import Foundation

enum CardColor{
    case red, green, blue
}
enum CardNumber {
    case one, two, three
}
enum CardShape {
    case triangle, circle, square
}
enum CardShading {
    case empty, full, striped
}

class Card {
    var color: CardColor
    var number: CardNumber
    var shape: CardShape
    var shading: CardShading
    
    var isInAMatchedSet: Bool = false

    init(color: CardColor, number: CardNumber,
         shape: CardShape, shading: CardShading) {
        self.color = color
        self.number = number
        self.shape = shape
        self.shading = shading
    }
}




/*
 set Rules
 81 unique cards
 4 possible features
     each have 3 choices
         color, number, shape, fill
 
 SET IF
 all are different
 1 characteristic  are the same 3 are different
 2 characteristics are the same 2 are different
 3 characteristics are the same 1 are different
 
 NOT A SET IF
    characteristics partially match

 */

















