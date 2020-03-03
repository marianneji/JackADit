//
//  ViewController.swift
//  JackADit
//
//  Created by Graphic Influence on 27/02/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButtons: [CircularButton]!

    @IBOutlet weak var actionButton: UIButton!

    @IBOutlet var playerLabels: [UILabel]!
    
    @IBOutlet var scoreLabels: [UILabel]!

    var currentPlayer = 0
    var scores = [0,0]
    var gameEnded = false

    var sequenceIndex = 0
    var colorSequence = [Int]()
    var colorsToTap = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGame()
        sortUI()
    }

    fileprivate func sortUI() {
        colorButtons = colorButtons.sorted() {
            $0.tag < $1.tag
        }
        playerLabels = playerLabels.sorted() {
            $0.tag < $1.tag
        }
        scoreLabels = scoreLabels.sorted() {
            $0.tag < $1.tag
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            gameEnded = false
            createNewGame()
        }
    }

    func createNewGame() {
        colorSequence.removeAll()
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        enableButtons(false)
        for button in colorButtons {
            button.alpha = 0.5
        }
        currentPlayer = 0
        scores = [0,0]
        playerLabels[currentPlayer].alpha = 1.0
        playerLabels[1].alpha = 0.75
        updateScore()
    }

    func updateScore() {
        for (index, label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }

    func switchPlayers() {
        playerLabels[currentPlayer].alpha = 0.75
        currentPlayer = currentPlayer == 0 ? 1 : 0
        playerLabels[currentPlayer].alpha = 1.0
    }

    func addNewColor() {
        colorSequence.append(Int.random(in: 0..<4))
    }

    func playSequence() {
        if sequenceIndex < colorSequence.count {
            flash(button: colorButtons[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        } else {
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true
            actionButton.setTitle("Tap the circles", for: .normal)
            enableButtons(true)
        }
    }

    func flash(button: CircularButton) {
        UIView.animate(withDuration: 0.5, animations: {
            button.alpha = 1.0
            button.alpha = 0.5
        }) { (bool) in
            self.playSequence()
        }
    }

    fileprivate func enableButtons(_ enable: Bool) {
        for button in colorButtons {
            button.isEnabled = enable
        }
    }

    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 wins!" : "Player 1 wins!"
        actionButton.setTitle(message, for: .normal)
        gameEnded = true

    }

    @IBAction func colorButtonHandler(_ sender: CircularButton) {
        if sender.tag == colorsToTap.removeFirst() {

        } else {
            enableButtons(false)
            endGame()
            return
        }
        if colorsToTap.isEmpty {
            enableButtons(false)
            scores[currentPlayer] += 1
            updateScore()
            switchPlayers()
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
    }

    @IBAction func actionButtonHandler(_ sender: UIButton) {
        sequenceIndex = 0
        actionButton.setTitle("Memorize", for: .normal)
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        addNewColor()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
    
}

