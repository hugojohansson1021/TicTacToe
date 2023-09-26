//
//  ViewController.swift
//  TicTacToe
//
//  Created by Hugo Johansson on 2023-09-12.
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
    
    @IBOutlet weak var noughtNameTextField: UITextField!
    @IBOutlet weak var crossNameTextField: UITextField!
    
    
    //create an array of buttons called board
    var board = [UIButton]()
    
    
    // Score board
    var noughtScore =  0
    var crossScore = 0
    
   
    @IBAction func tapAction(_ sender: UIButton)
    {
        addToBoard(sender)
        
        if checkForWinner(CROSS)
        {
            crossScore += 1
            resultAlert(title: "\(crossNameTextField.text ?? "Cross") Wins!")
        }
        
        if checkForWinner(NOUGHT)
        {
            noughtScore += 1
            resultAlert(title: "\(noughtNameTextField.text ?? "Nought") Wins!")
        }
        
        
        if(fullBoard())
        {
            resultAlert(title: "Draw")
        }
    }
    

    
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
    
    
    
    // send the result as an alert w reset button
    func resultAlert(title:String)
    {
        
        
        sendScoreToDiscord()
       
        let message = "\n\(noughtNameTextField.text ?? "Nought"): \(noughtScore)\n\n\(crossNameTextField.text ?? "Cross"): \(crossScore)"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
        
    }
    
    
    
    
    
    // using Swifts URLSession to HTTP-call to thw discord webbkhook, to send a notifacation

    func sendScoreToDiscord()
    {
        let discordWebhookURL = "https://discord.com/api/webhooks/1155958271404945478/gOCPhhEJSZBtuBny3oid9wmJtrJTpaWuM-bhlGsEcpDQ_Lpq07DYajTvigOYmiHw6w_w"
        
        
        //create data for discord
        //construct the message content that will be sent to Discord.
        //creates two strings, noughtScoreText and crossScoreText,
        
        
        let noughtName = noughtNameTextField.text ?? "Nought"
        let crossName = crossNameTextField.text ?? "Cross"

        let noughtScoreText = "\(noughtName): \(noughtScore)"
        let crossScoreText = "\(crossName): \(crossScore)"

        
        
        let message = "\(noughtScoreText)\n\(crossScoreText)"
        
        
        // check if the url is valid
        if let url = URL(string: discordWebhookURL)
        {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"// set metod tp POST to send message
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")//set content type to json data
            
            // Skapa JSON-data att skicka
            let jsonData: [String: Any] = [
                "content": message
            ]
            
            //use HTTPBODY property
            do {
                let requestBody = try JSONSerialization.data(withJSONObject: jsonData)//creats json data bibleotek
                request.httpBody = requestBody
                
                let task = URLSession.shared.dataTask(with: request)
                { (data, response, error) in
                    if let error = error
                    {
                        print("Error sending message to Discord: \(error)")
                    }
                    else
                    {
                        print("Message sent to Discord successfully")
                    }
                }
                
                task.resume()
            }
            catch
            {
                print("Error serializing JSON: \(error)")
            }
        }
    }


    
    func resetBoard() {
           for button in board {
               button.setTitle(nil, for: .normal)
               button.isEnabled = true
           }
           
           let noughtName = noughtNameTextField.text ?? "Nought"
           let crossName = crossNameTextField.text ?? "Cross"
           
           turnLabel.text = firstTurn == Turn.Nought ? noughtName : crossName
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
            if sender.title(for: .normal) == nil {
                if currentTurn == Turn.Nought {
                    sender.setTitle("O", for: .normal)
                    currentTurn = Turn.Cross
                    turnLabel.text = crossNameTextField.text ?? "Cross"
                } else if currentTurn == Turn.Cross {
                    sender.setTitle("X", for: .normal)
                    currentTurn = Turn.Nought
                    turnLabel.text = noughtNameTextField.text ?? "Nought"
                }
                sender.isEnabled = false // To remove animation if it is already pressed
            }
        }
    
    
}

