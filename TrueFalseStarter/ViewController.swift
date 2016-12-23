
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 6
    var questionsAsked = 0
    var correctQuestions = 0
    var questions = Questions()
    var questionSet: [Trivia] = []
    var defaultChoiceButtonColor: UIColor = UIColor.white
    
    var gameSound: SystemSoundID = 0
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var fourthChoiceButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialSetup() {
        firstChoiceButton.layer.cornerRadius = 15
        secondChoiceButton.layer.cornerRadius = 15
        thirdChoiceButton.layer.cornerRadius = 15
        fourthChoiceButton.layer.cornerRadius = 15
        playAgainButton.layer.cornerRadius = 15
        defaultChoiceButtonColor = firstChoiceButton.backgroundColor!
        questionSet = questions.questionSet(for: questionsPerRound)
    }
    
    func resetButtonColor() {
        firstChoiceButton.backgroundColor = defaultChoiceButtonColor
        secondChoiceButton.backgroundColor = defaultChoiceButtonColor
        thirdChoiceButton.backgroundColor = defaultChoiceButtonColor
        fourthChoiceButton.backgroundColor = defaultChoiceButtonColor
    }
    
    func displayQuestion() {
        resetButtonColor()
        
        
        let questionDictionary = questionSet[questionsAsked]
        questionField.text = questionDictionary.question
        firstChoiceButton.setTitle(questionDictionary.firstOption, for: .normal)
        secondChoiceButton.setTitle(questionDictionary.secondOption, for: .normal)
        thirdChoiceButton.setTitle(questionDictionary.thirdOption, for: .normal)
        fourthChoiceButton.setTitle(questionDictionary.fourthOption, for: .normal)
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        firstChoiceButton.isHidden = true
        secondChoiceButton.isHidden = true
        thirdChoiceButton.isHidden = true
        fourthChoiceButton.isHidden = true
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = questionSet[questionsAsked - 1]
        print(selectedQuestionDict.correct)
        let correctAnswer = selectedQuestionDict.correct
        
        if (sender === firstChoiceButton && correctAnswer == 1) || (sender === secondChoiceButton && correctAnswer == 2) || (sender === thirdChoiceButton && correctAnswer == 3) || (sender === fourthChoiceButton && correctAnswer == 4) {
            correctQuestions += 1
            questionField.text = "Correct!"
            highlightButton(for: sender, with: "green")
        } else {
            questionField.text = "Sorry, wrong answer!"
            switch correctAnswer {
            case 1: highlightButton(for: firstChoiceButton, with: "green")
            case 2: highlightButton(for: secondChoiceButton, with: "green")
            case 3: highlightButton(for: thirdChoiceButton, with: "green")
            case 4: highlightButton(for: fourthChoiceButton, with: "green")
            default: print("This should never be printed")
            }
            highlightButton(for: sender, with: "red")
        }
        loadNextRoundWithDelay(seconds: 1)
    }
    
    func highlightButton(for button: UIButton, with color: String) {
        if color == "red" {
            button.backgroundColor = UIColor.red
        } else if color == "green" {
            button.backgroundColor = UIColor.green
        } else {
            print("Nothing Happened!")
        }
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        firstChoiceButton.isHidden = false
        secondChoiceButton.isHidden = false
        thirdChoiceButton.isHidden = false
        fourthChoiceButton.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        questionSet = questions.questionSet(for: questionsPerRound)
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

