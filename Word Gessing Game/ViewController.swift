//
//  ViewController.swift
//  Word Gessing Game
//
//  Created by Henry Aguinaga on 2016-11-28.
//  Copyright © 2016 Henry Aguinaga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblHint: UILabel!
    @IBOutlet weak var lblNumberOfGuesses: UILabel!
    @IBOutlet weak var lblWordProgress: UILabel!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var labLettersGuessed: UILabel!
    
    let listOfWords : [[Character]] = [["m"," ","a"," ","m"," ","m"," ","o"," ","t"," ","h"," "],
                                       ["f"," ","o"," ","o"," ","t"," ","b"," ","a"," ","l"," ","l"," "],
                                       ["m"," ","o"," ","u"," ","s"," ","e"," "],
                                       ["b"," ","a"," ","n"," ","a"," ","n"," ","a"," "]]
    
    let listOfHints : [String] = ["extinct animal, 7 letters",
                                  "popular sport, 8 letters",
                                  "small animal, 5 letters",
                                  "yellow fruit, 6 letters"]
    
    
    var randomNumber : Int?
    var lastRandomNumber : Int?
    var wordToGuess : [Character] = []
    var wordProgress: [Character] = []
    var score : Int = 5
    let maxScore : Int = 5
    var lettersBank : String = "Letters guessed:   "
    var listOflettersGuess : [Character] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressNewWordButton(_ sender: UIButton) {
       
        listOflettersGuess.removeAll()
        wordProgress = []
        score = 5
        lettersBank.removeAll()
        labLettersGuessed.text = "Letters guessed:  "
        lblNumberOfGuesses.text = "5/5 guesses left"
        setRandomNumber()
         txtInput.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtInput.text != nil {
            let letter = Character(txtInput.text!)
            guessLetter(letterGuess: letter)
            txtInput.becomeFirstResponder()
            txtInput.text?.removeAll()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtInput.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = NSCharacterSet.letters
        let startingLength = txtInput.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if string.isEmpty {
            return true
        } else if newLength == 1 {
            if let _ = string.rangeOfCharacter(from: allowedCharacters) {
                return true
            }
        }
        
        return false
        
    }
    
    func setRandomNumber() {
        randomNumber = Int(arc4random_uniform(UInt32(listOfWords.count)))
        if randomNumber == lastRandomNumber {
            setRandomNumber()
        }
        lastRandomNumber = randomNumber
        setWordToGuessAndHint()
        setWordProgress()
        
    }
    
    func setWordToGuessAndHint() {
        wordToGuess = listOfWords[randomNumber!]
        lblHint.text = "Hint: " + listOfHints[randomNumber!]
    }
    
    func setWordProgress() {
        for _ in 0..<(wordToGuess.count / 2) {
            wordToGuess.append("_")
            wordToGuess.append(" ")
        }
        lblWordProgress.text = String(wordProgress)
    }
    
    func guessLetter(letterGuess: Character) {
        if !(listOflettersGuess.contains(letterGuess)) {
            var containsLetter : Bool = false
            for index in 0..<wordToGuess.count {
                if wordToGuess[index] == letterGuess {
                    revealLetter(_index: index, _letter: letterGuess)
                    containsLetter = true
                }
            }
            if containsLetter == true {
                addLetterToBank(letter: letterGuess)
                
                lblNumberOfGuesses.text = "Yep!" + String(score) + "/" + String(maxScore) + " guesses left"
                
            } else {
                score -= 1
                addLetterToBank(letter: letterGuess)
                lblNumberOfGuesses.text = "Nope!" + String(score) + "/" + String(maxScore) + " guesses left"
            }
            checkIfEndGame()
        }
    }
    
    func revealLetter(_index : Int, _letter : Character) {
        wordProgress[_index] = _letter
        
        lblWordProgress.text = String(wordProgress)
    }
    
    func addLetterToBank(letter : Character) {
        listOflettersGuess.append(letter)
        lettersBank.append(String(letter) + " ")
        labLettersGuessed.text = "Letters guessed: " + lettersBank
    }
    
    func checkIfEndGame() {
        if wordProgress == wordToGuess {
            lblHint.text = "YOU GUESSED IT!"
            txtInput.isEnabled = false
            
        } else if score == 0 {
            lblHint.text = "Good try but not quite!"
            txtInput.isEnabled = false
        }
    }
}











