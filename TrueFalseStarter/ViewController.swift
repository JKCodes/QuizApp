
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    // Constants
    let questionsPerRound = 6
    let countdownDuration = 15
    
    // Variables
    var questionsAsked = 0
    var correctQuestions = 0
    var questions = Questions()
    var questionSet: [Trivia] = []
    var defaultChoiceButtonColor = UIColor()
    
    // Varibles used for the lightning mode
    var currentCountdown = 0
    var countdownTimer = Timer()
    
    // Toggles if the answers can be chosen or not
    // This is mainly to prevent rapid clicking of the answer
    var canChoose = true
    
    var gameSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var wrongSound: SystemSoundID = 0
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var fourthChoiceButton: UIButton!
    @IBOutlet weak var firstButtonVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var secondButtonVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var countdownField: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        loadGameSounds()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Next two functions moves around buttons depending on
    // the number of choices for the question
    func threeOptionQuestionSetup() {
        fourthChoiceButton.isHidden = true
        firstButtonVerticalSpacing.constant = 70
        secondButtonVerticalSpacing.constant = 70
    }
    
    func fourOptionQuestionSetup() {
        fourthChoiceButton.isHidden = false
        firstButtonVerticalSpacing.constant = 30
        secondButtonVerticalSpacing.constant = 30
    }
    
    func initialSetup() {
        
        // Creates a border radius for all buttons
        firstChoiceButton.layer.cornerRadius = 15
        secondChoiceButton.layer.cornerRadius = 15
        thirdChoiceButton.layer.cornerRadius = 15
        fourthChoiceButton.layer.cornerRadius = 15
        playAgainButton.layer.cornerRadius = 15
        
        // Stores the default color for the choice buttons
        defaultChoiceButtonColor = firstChoiceButton.backgroundColor!
        
        // Loads a specified number of questions from the database
        questionSet = questions.questionSet(for: questionsPerRound)
        
        // The default view is initially for 4 choice question.
        // Does the very first question (on app load) have 3 choices?
        if questionSet[0].fourthOption == "" {
            threeOptionQuestionSetup()
        }
    }
    
    /// Resets all highlighted buttons to the default button color
    func resetButtonColor() {
        firstChoiceButton.backgroundColor = defaultChoiceButtonColor
        secondChoiceButton.backgroundColor = defaultChoiceButtonColor
        thirdChoiceButton.backgroundColor = defaultChoiceButtonColor
        fourthChoiceButton.backgroundColor = defaultChoiceButtonColor
    }
    
    func displayQuestion() {
        
        // Quick resets and setup
        currentCountdown = countdownDuration
        
        // Alows the user to select an answer
        canChoose = true
        
        resetButtonColor()
        if questionSet[questionsAsked].fourthOption == "" {
            threeOptionQuestionSetup()
        }
        
        if questionSet[questionsAsked].fourthOption != "" {
            fourOptionQuestionSetup()
        }
        
        
        // Set up initial data for the displayed question
        let questionDictionary = questionSet[questionsAsked]
        questionField.text = questionDictionary.question
        countdownField.text = "\(currentCountdown) second(s) left to answer"
        firstChoiceButton.setTitle(questionDictionary.firstOption, for: .normal)
        secondChoiceButton.setTitle(questionDictionary.secondOption, for: .normal)
        thirdChoiceButton.setTitle(questionDictionary.thirdOption, for: .normal)
        fourthChoiceButton.setTitle(questionDictionary.fourthOption, for: .normal)
        playAgainButton.isHidden = true
        
        // Runs the timer every second
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timedQuestion(_:)), userInfo: nil, repeats: true )
        
    }
    
    /// Decrements the countdown variable and ends the round if the counter reaches zero
    func timedQuestion(_ timer: Timer) {
        currentCountdown -= 1
        
        if currentCountdown == 0 {
            canChoose = false
            processUnansweredQuestion()
            loadNextRoundWithDelay(seconds: 1)
        }
        
        // Updates the countdown field text every second
        countdownField.text = "\(currentCountdown) second(s) left to answer"
    }

    /// Run this if the countdown reaches zero
    func processUnansweredQuestion() {
        // Invalidate the no-longer needed timer
        countdownTimer.invalidate()
        
        // Grabs the index of the correct answer
        let correctButtonIndex = questionSet[questionsAsked].correct
        
        // Displays the correct answer based on the correct answer index
        switch correctButtonIndex {
        case 1: highlightButton(for: firstChoiceButton, with: "green")
        case 2: highlightButton(for: secondChoiceButton, with: "green")
        case 3: highlightButton(for: thirdChoiceButton, with: "green")
        case 4: highlightButton(for: fourthChoiceButton, with: "green")
        default: print("This should never be printed")
        }

        // Increments question asked counter by one - a.k.a count the question as wrong
        // Then it plays the wrong sound
        questionsAsked += 1
        playWrongSound()
    }
    
    func displayScore() {
        var evaluation: String = ""
        let score = 100 * correctQuestions / questionsPerRound
        // Hide the answer buttons and the countdown field
        firstChoiceButton.isHidden = true
        secondChoiceButton.isHidden = true
        thirdChoiceButton.isHidden = true
        fourthChoiceButton.isHidden = true
        countdownField.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        if score == 100 {
            evaluation = "Wow! You are amazing!"
        } else if score >= 83 {
            evaluation = "Way to go!"
        } else if score >= 66 {
            evaluation = "Not too bad!"
        } else if score >= 50 {
            evaluation = "You can do better, right?"
        } else {
            evaluation = "Were you trying?"
        }
        
        questionField.text = "\(evaluation)\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // If flagged as 'can't choose', return right away
        if !canChoose {
            return
        }
        
        // Invalidate the no-longer necessary Timer
        countdownTimer.invalidate()
        
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = questionSet[questionsAsked - 1]
        let correctAnswer = selectedQuestionDict.correct
        
        // Checks and highlights answers
        if (sender === firstChoiceButton && correctAnswer == 1) || (sender === secondChoiceButton && correctAnswer == 2) || (sender === thirdChoiceButton && correctAnswer == 3) || (sender === fourthChoiceButton && correctAnswer == 4) {
            playCorrectSound()
            correctQuestions += 1
            questionField.text = "Correct!"
            highlightButton(for: sender, with: "green")
        } else {
            playWrongSound()
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
        
        // Change the flag so that the player can't guess again during the delay timer
        canChoose = false
        loadNextRoundWithDelay(seconds: 1)
    }
    
    func highlightButton(for button: UIButton, with color: String) {
        if color == "red" {
            button.backgroundColor = UIColor.red
        } else if color == "green" {
            button.backgroundColor = UIColor.green
        } else {
            // This should never be printed if programmed correctly
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
        // Show the answer buttons and the countdown field
        firstChoiceButton.isHidden = false
        secondChoiceButton.isHidden = false
        thirdChoiceButton.isHidden = false
        fourthChoiceButton.isHidden = false
        countdownField.isHidden = false
        
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
    
    
    /// Loads all three sounds used by this game
    func loadGameSounds() {
        var pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        var soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
        
        pathToSoundFile = Bundle.main.path(forResource: "Correct", ofType: "wav")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &correctSound)
        
        pathToSoundFile = Bundle.main.path(forResource: "Wrong", ofType: "wav")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &wrongSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func playWrongSound() {
        AudioServicesPlaySystemSound(wrongSound)
    }
}

