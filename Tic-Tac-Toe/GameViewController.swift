//
//  GameViewController.swift
//  Tic-Tac-Toe
//
//  Created by Ahmet Enes Irmak on 20.08.2022.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: Variables
    var playerName: String!
    var lastValue = "o"
    
    var playerChoices: [Box] = []
    var computerChoices: [Box] = []

    //MARK: IBOutlets
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var computerScoreLabel: UILabel!
    
    @IBOutlet weak var box1: UIImageView!
    @IBOutlet weak var box2: UIImageView!
    @IBOutlet weak var box3: UIImageView!
    @IBOutlet weak var box4: UIImageView!
    @IBOutlet weak var box5: UIImageView!
    @IBOutlet weak var box6: UIImageView!
    @IBOutlet weak var box7: UIImageView!
    @IBOutlet weak var box8: UIImageView!
    @IBOutlet weak var box9: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerNameLabel.text = playerName + ":"
        
        createTap(on: box1, type: .one)
        createTap(on: box2, type: .two)
        createTap(on: box3, type: .three)
        createTap(on: box4, type: .four)
        createTap(on: box5, type: .five)
        createTap(on: box6, type: .six)
        createTap(on: box7, type: .seven)
        createTap(on: box8, type: .eight)
        createTap(on: box9, type: .nine)
    }
    
    func createTap(on imageView: UIImageView, type box: Box) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.boxClicked(_:)))
        tap.name = box.rawValue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func boxClicked(_ sender: UITapGestureRecognizer) {
        print("Box: \(sender.name) was clicked.")
        let selectedBox = getBox(from: sender.name ?? "")
        makeChoice(selectedBox)
        playerChoices.append(Box(rawValue: sender.name!)!)
        checkIfWon()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.computerPlay()
        }
    }
    
    func computerPlay() {
        var avaliableSpaces = [UIImageView]()
        var avaliableBoxes = [Box]()
        
        for name in Box.allCases {
            let box = getBox(from: name.rawValue)
            if box.image == nil {
                avaliableSpaces.append(box)
                avaliableBoxes.append(name)
            }
        }
        
        guard avaliableBoxes.count > 0 else { return }
        
        let randIndex = Int.random(in: 0 ..< avaliableSpaces.count)
        makeChoice(avaliableSpaces[randIndex])
        computerChoices.append(avaliableBoxes[randIndex])
        checkIfWon()
    }
    
    func makeChoice(_ selectedBox: UIImageView) {
        guard selectedBox.image == nil else { return }
        
        if lastValue == "x" {
            selectedBox.image = #imageLiteral(resourceName: "oh")
            lastValue = "o"
        } else {
            selectedBox.image = #imageLiteral(resourceName: "ex")
            lastValue = "x"

        }
    }
    
    func checkIfWon() {
        var correct = [[Box]]()
        let firstRow: [Box] = [.one, .two, .three]
        let secondRow: [Box] = [.four, .five, .six]
        let thirdRow: [Box] = [.seven, .eight, .nine]
        
        let firstColumn: [Box] = [.one, .four, .seven]
        let secondColumn: [Box] = [.two, .five, .eight]
        let thirdColumn: [Box] = [.three, .six, .nine]
        
        let backwardSlash: [Box] = [.one, .five, .nine]
        let forwardSlash: [Box] = [.three, .five, .seven]
        
        correct.append(firstRow)
        correct.append(secondRow)
        correct.append(thirdRow)
        correct.append(firstColumn)
        correct.append(secondColumn)
        correct.append(thirdColumn)
        correct.append(backwardSlash)
        correct.append(forwardSlash)
        
        for valid in correct {
            let userMatch = playerChoices.filter {valid.contains($0)}.count
            let computerMatch = computerChoices.filter {valid.contains($0)}.count
            
            if userMatch == valid.count {
                playerScoreLabel.text = String((Int(playerScoreLabel.text ?? "") ?? 0) + 1)
                resetGame()
                break
            }
            
            else if computerMatch == valid.count {
                computerScoreLabel.text = String((Int(computerScoreLabel.text ?? "") ?? 0) + 1)
                resetGame()
                break
            }
            
            else if computerChoices.count + playerChoices.count == 9 {
                resetGame()
                break
            }
        }
    }
    
    func resetGame() {
        for name in Box.allCases {
            let box = getBox(from: name.rawValue)
            box.image = nil
        }
        lastValue = "o"
        playerChoices = []
        computerChoices = []
        
    }
    
    
    
    func getBox(from name: String) -> UIImageView {
        let box = Box(rawValue: name) ?? .one
        switch box {
        case .one:
            return box1
        case .two:
            return box2
        case .three:
            return box3
        case .four:
            return box4
        case .five:
            return box5
        case .six:
            return box6
        case .seven:
            return box7
        case .eight:
            return box8
        case .nine:
            return box9
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

enum Box: String, CaseIterable {
    case one, two, three, four, five, six, seven, eight, nine
}
