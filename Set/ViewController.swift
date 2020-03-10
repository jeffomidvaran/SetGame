//
//  ViewController.swift
//  Set
//
//  Created by jeffomidvaran on 3/4/20.
//  Copyright © 2020 jeffomidvaran. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var game = SetGame()
    var audioPlayer = AVAudioPlayer()
    let buttonClickSoundPath = Bundle.main.path(forResource: "buttonClickSound", ofType: "mp3")
    let matchedSetSoundPath = Bundle.main.path(forResource: "successSound", ofType: "mp3")
    let gameWonSoundPath = Bundle.main.path(forResource: "gameWinSound", ofType: "mp3")
    let setFailSoundPath = Bundle.main.path(forResource: "failSound", ofType: "mp3")
    let newGameSoundPath = Bundle.main.path(forResource: "newGameSound", ofType: "mp3")
    var highlightedButtons = [CustomButton]()

    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var cardButtons: [CustomButton]!
    @IBAction func newGameButtonAction() {
        playButtonSound(soundPath: newGameSoundPath)
        removeAllCardLinksToButtons()
        game.createNewGame()
        assignCardsToUnassignedButtons()
        updateViewFromModel()
        messageLabel.text = "Find Sets of 3"
    }

    private func removeAllCardLinksToButtons() {
        for button in cardButtons {
            button.assignedCard = nil
        }
        highlightedButtons.removeAll()
    }
    
    override func viewDidLoad() {
        assignCardsToUnassignedButtons()
        updateViewFromModel()
    }

    @IBAction func CardButtonAction(_ sender: CustomButton) {
        // IF THE CARDBUTTON IS NOT EMPTY AND NOT ALREADY SELECTED
        if sender.assignedCard != nil {
            if !highlightedButtons.contains(sender) {
                playButtonSound(soundPath: buttonClickSoundPath!)
                highlightedButtons.append(sender) // pass by reference
                
                if highlightedButtons.count == 3 {
                    let isASet: Bool = game.isASet(
                        CardOne:   highlightedButtons[0].assignedCard!,
                        CardTwo:   highlightedButtons[1].assignedCard!,
                        CardThree: highlightedButtons[2].assignedCard!)
                    
                    if isASet {
                        messageLabel.text = "Set Found 😃"
                        playButtonSound(soundPath: matchedSetSoundPath)
                        game.numberOfMatches += 1
                        game.score += 1
                        for button in highlightedButtons {
                            button.assignedCard!.isInAMatchedSet = true
                            button.assignedCard = nil
                        }
                    } else {
                        messageLabel.text = "Not a Set 🙁 "
                        playButtonSound(soundPath: setFailSoundPath)
                        game.score -= 1
                    }
                    highlightedButtons.removeAll()
                    game.gameWon = checkToSeeIfPlayerHasWonTheGame()
                    assignCardsToUnassignedButtons()
                }
            } else if highlightedButtons.contains(sender) {
                playButtonSound(soundPath: buttonClickSoundPath!)
                let buttonIndex = highlightedButtons.firstIndex(of: sender)
                highlightedButtons.remove(at: buttonIndex!)
            }
        }
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        matchLabel.text = "Matches: \(game.numberOfMatches)"
        scoreLabel.text =  "Score: \(game.score)"
        
        // ADD HIGHLIGHT SHADING
        removeAllButtonHighlights()
        for button in highlightedButtons {
            makeButtonAppearHighlighted(forButton: button)
        }
        
        if game.gameWon {
            messageLabel.text = "You Win 🤩"
            playButtonSound(soundPath: gameWonSoundPath)
        }
        
        for button in cardButtons {
            if let card = button.assignedCard, !button.assignedCard!.isInAMatchedSet {
                button.showsTouchWhenHighlighted = true
                var buttonText: String = ""
                
                // ASSIGN COLOR
                switch card.color {
                    case .red: button.backgroundColor = .red
                    case .green: button.backgroundColor = .green
                    case .blue: button.backgroundColor = .blue
                }
                
                // ASSIGN SHAPES
                switch card.shape {
                    case .triangle: buttonText = "▲"
                    case .circle: buttonText = "●"
                    case .square: buttonText = "■"
                }
                
                // ASSIGN NUMBER
                switch card.number {
                case .one:
                    break
                case .two:
                    buttonText += buttonText
                case .three:
                    buttonText = buttonText + buttonText + buttonText
                }
                
                button.setTitle(buttonText, for: .normal)
                
                // ASSIGN SHADING
                switch card.shading {
                case .empty:
                    button.setTitleColor(.yellow, for: .normal)
                case .full:
                    button.setTitleColor(.white, for: .normal)
                case .striped:
                    button.setTitleColor(.orange, for: .normal)
                }
            }
            else {
                button.backgroundColor = #colorLiteral(red: 0.1334900856, green: 0.1450148821, blue: 0.1604738235, alpha: 1)
                button.setTitle("", for: .normal)
                button.showsTouchWhenHighlighted = false
            }
        }
    }


    
    private func checkToSeeIfPlayerHasWonTheGame() -> Bool {
        for button in cardButtons {
            if button.assignedCard != nil { return false }
        }
        return true
    }


    private func playButtonSound(soundPath: String?) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath!))
            audioPlayer.play()
        } catch {
            print("the sound could not be loaded")
        }
    }
    
    private func makeButtonAppearHighlighted(forButton button: CustomButton) {
        button.layer.borderWidth = 3.0
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func removeAllButtonHighlights() {
        for button in cardButtons {
            button.layer.borderWidth = 0.0
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }
    
    private func assignCardsToUnassignedButtons() {
        for button in cardButtons {
            if button.assignedCard == nil{
                // ASSIGN A CARD TO THE BUTTON
                for cardIndex in game.cards.indices {
                    let card = game.cards[cardIndex]
                    if !card.isInAMatchedSet {
                        let removedCard = game.cards.remove(at: cardIndex)
                        button.assignedCard = removedCard
                        break
                    }
                }
            }
        }
    }

}


enum SetError: Error {
    case buttonNotAssignedError
}


/* ######### To Do ############
    upload to git
*/

