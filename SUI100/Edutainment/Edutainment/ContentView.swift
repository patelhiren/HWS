//
//  ContentView.swift
//  Edutainment
//
//  Created by Hiren Patel on 4/9/21.
//

import SwiftUI

struct ContentView: View {
    
    static private var gameLevels = ["Easy", "Medium", "Hard"]
    static private var questionCountOptions = ["5", "10", "20", "All"]
    
    @State private var questions: Array<Question> = []
    @State private var selectedGameLevel = 1
    @State private var selectedMultiplicationNumber = 1
    @State private var selectedQuestionCount = 0
    @State private var isGameRunning = false
    @State private var currentQuestionNumber = 0
    @State private var currentAnswer = ""
    @State private var totalScore = 0
    
    var body: some View {
        ZStack (alignment: .top){
            LinearGradient(gradient: Gradient(colors: [.white, .purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ZStack (alignment: .leading) {
                    Color.purple
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 100)
                    Text("🦁 Multiplication Game")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                }
                
                if (!isGameRunning) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Pick Multiplicaiton Table")
                            .labelStyle()
                        HStack {
                            Stepper(value: $selectedMultiplicationNumber, in: 1...12) {
                                Text("\(selectedMultiplicationNumber)")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .padding()
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }.frame(maxWidth: .infinity)
                        
                        Text("Difficulty Level")
                            .labelStyle()
                        Picker("Difficulty Level", selection: $selectedGameLevel) {
                            ForEach(0 ..< ContentView.gameLevels.count) {
                                Text("\(ContentView.gameLevels[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Text("How many questions")
                            .labelStyle()
                        Picker("Difficulty Level", selection: $selectedQuestionCount) {
                            ForEach(0 ..< ContentView.questionCountOptions.count) {
                                Text("\(ContentView.questionCountOptions[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        HStack {
                            Spacer()
                            Button(action: {
                                self.startGame()
                            }) {
                                Text("Start Game")
                            }
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                else {
                    VStack(alignment: .leading, spacing: 16) {
                        if(self.currentQuestionNumber < self.totalQuestionCount) {
                            let currentQuestion = self.questions[self.currentQuestionNumber]
                            Text("\(currentQuestion.text)")
                                .questionStyle()
                            
                            TextField("Enter your answer here", text: $currentAnswer)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            HStack {
                                Text("Question: \(self.currentQuestionNumber + 1)/\(self.totalQuestionCount)")
                                Spacer()
                                Button(action: {
                                    self.checkAnswerAndAdvance()
                                }) {
                                    Text("Next")
                                }
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                        else {
                            Text("Your Score: \(totalScore)")
                                .questionStyle()
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.endGame()
                                }) {
                                    Text("New Game")
                                }
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private func startGame() {
        self.generateQuestions()
        
        self.isGameRunning = true
    }
    
    private func checkAnswerAndAdvance() {
        guard let answer = Int(self.currentAnswer) else {
            return
        }
        let question = self.questions[self.currentQuestionNumber]
        
        if question.answer == answer {
            totalScore += 1
        }
        
        self.currentAnswer = ""
        self.currentQuestionNumber+=1
    }
    
    private func endGame() {
        self.questions.removeAll()
        self.totalScore = 0
        self.currentQuestionNumber = 0
        self.currentAnswer = ""
        self.isGameRunning = false
    }
    
    private var minSecondNumber: Int {
        switch self.selectedGameLevel {
        case 0:
            return 0
        case 2:
            return 20
        default:
            return 10
        }
    }
    
    private var maxSecondNumber: Int {
        switch self.selectedGameLevel {
        case 0:
            return 10
        case 2:
            return 30
        default:
            return 20
        }
    }
    
    private var totalQuestionCount: Int {
        switch self.selectedQuestionCount {
        case 0:
            return 5
        case 1:
            return 10
        case 2:
            return 20
        default:
            return 30
        }
    }
    
    private func generateQuestions() {
        let firstNumber = self.selectedMultiplicationNumber
        
        for _ in 0..<totalQuestionCount {
            let secondNumber = Array(self.minSecondNumber...self.maxSecondNumber) .randomElement() ?? 10
            let question = Question(text: "What is \(firstNumber) x \(secondNumber)?", answer: firstNumber * secondNumber)
            self.questions.append(question)
        }
    }
}

extension Text {
    func labelStyle() -> some View {
        
        self
            .fontWeight(.medium)
            .modifier(ItemLabelViewModifier())
    }
    
    func questionStyle() -> some View {
        self
            .fontWeight(.black)
            .font(.title)
    }
}

struct ItemLabelViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
    }
}

struct Question {
    let text: String
    let answer: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
