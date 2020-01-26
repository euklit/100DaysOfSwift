//
//  ViewController.swift
//  Hangman
//
//  Created by Niklas Lieven on 24.01.20.
//  Copyright © 2020 euklit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var wordLabel: UITextField!
    var textField: UITextField!
    var enterButton: UIButton!
    var imageView: UIImageView!
    
    var wordToGuess = "Ketchup"
    var score = 1 {
        didSet {
            imageView.image = UIImage(named: "hangman\(score)")
        }
    }
    let words = ["Ketchup", "Relativity","Einstein", "Apple", "Swift", "recycling"].shuffled()
    
    var wordIndex = -1 {
        didSet {
            wordToGuess = words[wordIndex].uppercased()
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.isOpaque = true
        
        wordLabel = UITextField()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.defaultTextAttributes.updateValue(10, forKey: NSAttributedString.Key.kern)
        wordLabel.font = UIFont.systemFont(ofSize: 40)
        wordLabel.isEnabled = false
        wordLabel.text = "???????"
        
        view.addSubview(wordLabel)
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.keyboardType = .alphabet
        textField.autocorrectionType = .no
        textField.placeholder = "Enter character"
        textField.textAlignment = .center
        textField.becomeFirstResponder()
        view.addSubview(textField)
        
        enterButton = UIButton()
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.setTitle("Enter", for: .normal)
        enterButton.backgroundColor = .blue
        enterButton.layer.cornerRadius = 10
        enterButton.addTarget(self, action: #selector(checkLetter), for: .touchUpInside)
        view.addSubview(enterButton)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "hangman1")
        imageView.scalesLargeContentImage = true
        view.addSubview(imageView)
        
        
        // layout doesnt work with iphone se
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            wordLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            wordLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            imageView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            textField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            textField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            enterButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15),
            enterButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            enterButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .light
        loadNewWord()
        // Do any additional setup after loading the view.
    }
    
    @objc func checkLetter() {
        var labelArr = Array(wordLabel.text ?? "")
        let wordArr = Array(wordToGuess)
        
        if textField.text?.count == 1 {
            let char = Character(textField.text!.uppercased()) // safe to force unwrap because we checked its not nil
            
            if wordLabel.text!.contains(char) || !wordToGuess.contains(char) { // already used the letter or its not in the word to guess
                score += 1
                if score == 8 {
                    gameOver()
                }
            }
            
            // replace ? with correct letter
            for (position, letter) in wordArr.enumerated() {
                if letter == char {
                    labelArr[position] = letter
                }
            }
            
            wordLabel.text = labelArr.map { String($0) }.joined(separator: "")
            textField.text = ""
            
            if wordLabel.text == wordToGuess {
                correctWord()
            }
            
        } else { // no letter or more than one letter found
            let ac = UIAlertController(title: "Please enter exactly one letter", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            ac.addAction(action)
            present(ac, animated: true)
        }
    }
    
    func gameOver() {
        let ac = UIAlertController(title: "Game Over!", message: "The correct word was \(wordToGuess)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try next word", style: .default) { action in
            self.loadNewWord()
        }
        
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func loadNewWord() {
        self.score = 1
        self.wordIndex += 1
        self.wordLabel.text = [String](repeating: "?", count: self.wordToGuess.count).joined()
        
    }
    
    func correctWord() {
        let ac = UIAlertController(title: "Good job!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Next word", style: .default, handler: { _ in self.loadNewWord()})
        
        ac.addAction(action)
        present(ac, animated: true)
    }


}

