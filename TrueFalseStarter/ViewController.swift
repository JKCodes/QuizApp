//
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
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var defaultChoiceButtonColor: UIColor = UIColor.white
    
    var gameSound: SystemSoundID = 0
    
    struct Trivia {
        let question: String
        let firstOption: String
        let secondOption: String
        let thirdOption: String
        let fourthOption: String
        let correct: Int
    }
    
    let questionList: [Trivia] = [
        Trivia(question: "This was the only US President to serve more than two consecutive terms.", firstOption: "George Washington", secondOption: "Franklin D. Roosevelt", thirdOption: "Woodrow Wilson", fourthOption: "Andrew Jackson", correct: 2),
        Trivia(question: "Which of the following countries has the most residents?", firstOption: "Nigeria", secondOption: "Russia", thirdOption: "Iran", fourthOption: "Vietnam", correct: 1),
        Trivia(question: "In what year was the United Nations founded?", firstOption: "1918", secondOption: "1919", thirdOption: "1945", fourthOption: "1954", correct: 3),
        Trivia(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", firstOption: "Paris", secondOption: "Washington D.C.", thirdOption: "New York City", fourthOption: "Boston", correct: 3),
        Trivia(question: "Which nation produes the most oil?", firstOption: "Iran", secondOption: "Iraq", thirdOption: "Brazil", fourthOption: "Canada", correct: 4),
        Trivia(question: "Which country has most recently won consecurive World Cups in soccer?", firstOption: "Italy", secondOption: "Brazil", thirdOption: "Argentina", fourthOption: "Spain", correct: 2),
        Trivia(question: "Which of the following rivers is longest?", firstOption: "Yangtze", secondOption: "Mississippi", thirdOption: "Congo", fourthOption: "Mekong", correct: 2),
        Trivia(question: "Which city is the oldest?", firstOption: "Mexico City", secondOption: "Cape Town", thirdOption: "San Juan", fourthOption: "Sydney", correct: 1),
        Trivia(question: "Which country was the first to allow women to vote in national elections?", firstOption: "Poland", secondOption: "United States", thirdOption: "Sweden", fourthOption: "Senegal", correct: 1),
        Trivia(question: "Which of these countries won the most medals in the 2012 Summer Olympics?", firstOption: "France", secondOption: "Germany", thirdOption: "Japan", fourthOption: "Great Britain", correct: 4)
        ]
    
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
    }
    
    func resetButtonColor() {
        firstChoiceButton.backgroundColor = defaultChoiceButtonColor
        secondChoiceButton.backgroundColor = defaultChoiceButtonColor
        thirdChoiceButton.backgroundColor = defaultChoiceButtonColor
        fourthChoiceButton.backgroundColor = defaultChoiceButtonColor
    }
    
    func displayQuestion() {
        resetButtonColor()
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionList.count)
        let questionDictionary = questionList[indexOfSelectedQuestion]
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
        
        let selectedQuestionDict = questionList[indexOfSelectedQuestion]
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

