//
//  ViewController.swift
//  TicTacToe
//
//  Created by Hugo Johansson on 2023-09-19.
//

import UIKit

class ViewController: UIViewController
{
    // Declare enum
    enum Turn {
        case Nought
        case Cross
        
    }
    
    
    
    
    @IBOutlet weak var turnLabel: UILabel!
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    
    
    // declare variables
    
    var firstTurn = Turn.Cross// who will go first
    var currentTurn = Turn.Cross //will decide the current turn
    
    var NOUGHT = "O"
    var CROSS = "X"
    
    //create an array of buttons called board
    var board = [UIButton]()
    
    
    // Score board
    var noughtScore =  0
    var crossScore = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
    }
    
    func initBoard(){
        
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
        
    }
    
    
    
    @IBAction func tapAction(_ sender: UIButton)
    {
        addToBoard(sender)
        
        
        if checkForWinner(CROSS)
        {
            crossScore += 1
            resultAlert(title: "Cross Win..!")
        }
        
        if checkForWinner(NOUGHT)
        {
            noughtScore += 1
            resultAlert(title: "Nought Win..!")
        }
        
        
        if(fullBoard())
        {
            resultAlert(title: "Draw")
        }
    }
    
    
    func checkForWinner(_ s :String) -> Bool
    {
        // Horizontell winner
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s)
        {
            return true
        }
        
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s)
        {
            return true
        }
        
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s)
        {
            return true
        }
        
        
        // Vertikal winner
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s)
        {
            return true
        }
        
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s)
        {
            return true
        }
        
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s)
        {
            return true
        }
        
        // Diaqgonalt winner
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s)
        {
            return true
        }
        
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s)
        {
            return true
        }
        
        

        return false
    }
    
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool
    {
        return button.title(for: .normal) == symbol
    }
    
    
    
    
    func resultAlert(title:String)
    {
        let message = "\nO: " + String(noughtScore) + "\n\nX: " + String(crossScore)
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
        
    }
    
    
    
    
    func resetBoard()
    {
        for button in board
        {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == Turn.Nought
        {
            firstTurn = Turn.Cross
            turnLabel.text = CROSS
        }
        else if firstTurn == Turn.Cross
        {
            firstTurn = Turn.Nought
            turnLabel.text = NOUGHT
        }
        currentTurn = firstTurn

    }




    
    
    
    // create an boolean to check if empty spacxe on the board
    func fullBoard() -> Bool{
        for button in board
        {
            if button.title(for: .normal) == nil
            {
            return false
            }
        }
        return true
    }
    
    
    
    
    

    func addToBoard(_ sender: UIButton) {
    
        if(sender.title(for: .normal) == nil)
        {
            if(currentTurn == Turn.Nought)
            {
                sender.setTitle(NOUGHT, for: .normal)
                currentTurn = Turn.Cross
                turnLabel.text = CROSS
            }
           else if(currentTurn == Turn.Cross)
            {
                sender.setTitle(CROSS, for: .normal)
                currentTurn = Turn.Nought
                turnLabel.text = NOUGHT
            }
            sender.isEnabled =  false //To remove animation if it is already preasedd
        }
        
    }
    
    
    
    
}

