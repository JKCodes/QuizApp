//
//  TriviaData.swift
//  TrueFalseStarter
//
//  Created by Joseph Kim on 12/23/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import GameKit

struct Trivia {
    let question: String
    let firstOption: String
    let secondOption: String
    let thirdOption: String
    let fourthOption: String?
    let correct: Int
}

struct Questions {
    let questions = [
        Trivia(question: "This was the only US President to serve more than two consecutive terms.", firstOption: "George Washington", secondOption: "Franklin D. Roosevelt", thirdOption: "Woodrow Wilson", fourthOption: "Andrew Jackson", correct: 2),
        Trivia(question: "Which of the following countries has the most residents?", firstOption: "Nigeria", secondOption: "Russia", thirdOption: "Iran", fourthOption: "Vietnam", correct: 1),
        Trivia(question: "In what year was the United Nations founded?", firstOption: "1918", secondOption: "1919", thirdOption: "1945", fourthOption: "1954", correct: 3),
        Trivia(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", firstOption: "Paris", secondOption: "Washington D.C.", thirdOption: "New York City", fourthOption: "Boston", correct: 3),
        Trivia(question: "Which nation produes the most oil?", firstOption: "Iran", secondOption: "Iraq", thirdOption: "Brazil", fourthOption: "Canada", correct: 4),
        Trivia(question: "Which country has most recently won consecurive World Cups in soccer?", firstOption: "Italy", secondOption: "Brazil", thirdOption: "Argentina", fourthOption: "Spain", correct: 2),
        Trivia(question: "Which of the following rivers is longest?", firstOption: "Yangtze", secondOption: "Mississippi", thirdOption: "Congo", fourthOption: "Mekong", correct: 2),
        Trivia(question: "Which city is the oldest?", firstOption: "Mexico City", secondOption: "Cape Town", thirdOption: "San Juan", fourthOption: "Sydney", correct: 1),
        Trivia(question: "Which country was the first to allow women to vote in national elections?", firstOption: "Poland", secondOption: "United States", thirdOption: "Sweden", fourthOption: "Senegal", correct: 1),
        Trivia(question: "Which of these countries won the most medals in the 2012 Summer Olympics?", firstOption: "France", secondOption: "Germany", thirdOption: "Japan", fourthOption: "Great Britain", correct: 4),
        Trivia(question: "What is 111 * 111?", firstOption: "111111", secondOption: "12421", thirdOption: "12321", fourthOption: nil, correct: 3),
        Trivia(question: "Let's say I have 23 candles. One night, I lit 8 of them, then I went to sleep.  How many candles are left in the morning?", firstOption: "23", secondOption: "15", thirdOption: "8", fourthOption: nil, correct: 2)
    ]
    
    /// Returns a specified number of questions
    func questionSet(for number: Int) -> [Trivia] {
        var questionList: [Trivia] = []
        var iterator = 0
        var indexOfSelectedQuestion: Int
        var exist = false
        while (iterator < number) {
            while (iterator >= questionList.count) {
                exist = false
                indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
                if questionList.count == 0 {
                    questionList.append(questions[indexOfSelectedQuestion])
                }
                for question in questionList {
                    if question.question == questions[indexOfSelectedQuestion].question {
                        exist = true
                    }
                }
                if(!exist) {
                    questionList.append(questions[indexOfSelectedQuestion])
                }
            }
            iterator += 1
        }
        print(questionList)
        return questionList
    }

    
}
