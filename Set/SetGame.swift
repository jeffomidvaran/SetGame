//
//  SetGame.swift
//  Set
//
//  Created by jeffomidvaran on 3/4/20.
//  Copyright © 2020 jeffomidvaran. All rights reserved.
//

import Foundation

struct SetGame {
    internal var cards: [Card]
    internal var numberOfMatches = 0
    internal var score = 0
    internal var gameWon: Bool = false

    
    internal func isASet(CardOne card1: Card, CardTwo card2: Card, CardThree card3: Card) -> Bool {
        let colorMatch = same(val1: card1.color, val2: card2.color, val3: card3.color) ||
                         notTheSame(val1: card1.color, val2: card2.color, val3: card3.color)
        let numberMatch = same(val1: card1.number, val2: card2.number, val3: card3.number) ||
                          notTheSame(val1: card1.number, val2: card2.number, val3: card3.number)
        let shapeMatch = same(val1: card1.shape, val2: card2.shape, val3: card3.shape) ||
                         notTheSame(val1: card1.shape, val2: card2.shape, val3: card3.shape)
        let shadingMatch = same(val1: card1.shading, val2: card2.shading, val3: card3.shading) ||
                         notTheSame(val1: card1.shading, val2: card2.shading, val3: card3.shading)
        return colorMatch || numberMatch || shapeMatch || shadingMatch
    }
    
    private func same<T: Equatable>(val1 c1: T , val2 c2: T, val3 c3: T) -> Bool {
        return (c1 == c2 && c2 == c3)
    }
    
    private func notTheSame<T: Equatable> (val1 c1: T , val2 c2: T, val3 c3: T) -> Bool{
        return (c1 != c2 && c1 != c3 && c2 != c3)
    }
    
    
    private mutating func createCardsDeck() {
        let colors: [CardColor] = [CardColor.red, CardColor.green, CardColor.blue]
        let numbers: [CardNumber] = [CardNumber.one, CardNumber.two, CardNumber.three]
        let shapes: [CardShape] = [CardShape.triangle, CardShape.circle, CardShape.square]
        let shades: [CardShading] = [CardShading.empty, CardShading.full, CardShading.striped]
        
        // Actually O(n) will only touch each card once
        for color in colors {
            for number in numbers {
                for shape in shapes {
                    for shade in shades{
                        let newCard = Card(color: color, number: number, shape: shape, shading: shade)
                        self.cards.append(newCard)
                    }
                }
            }
        }
    }
    
    internal mutating func createNewGame() {
        self.cards.removeAll()
        createCardsDeck()
        self.cards.shuffle()
        self.numberOfMatches = 0
        self.score = 0
        self.gameWon = false
        
    }
    
    
    init() {
        self.cards = [Card]()
        createCardsDeck()
        self.cards.shuffle()
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
