//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Hiren Patel on 4/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var answeredCorrect: Bool?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0 ..< 3) { number in
                    FlagView(countryImageName: self.countries[number]) {
                        withAnimation {
                            self.flagTapped(number)
                        }
                    }
                    .disabled(answeredCorrect != nil)
                    .animateUserResponse(answeredCorrect: self.$answeredCorrect, representsCorrectItem: (number == correctAnswer))
                }
                VStack {
                    Text("Your Score")
                        .foregroundColor(.white)
                    Text("\(userScore)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                    if let correct = answeredCorrect {
                        Text("\(scoreTitle)")
                            .foregroundColor( correct ? .green : .red)
                            .font(.headline)
                            .padding()
                    }
                }
                Spacer()
                if let _ = answeredCorrect {
                    Button(action: askQuestion) {
                        Text("Play Again")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            scoreTitle = "Wrong! Thats the flag of \(countries[number])"
            userScore -= 1
        }
        
        answeredCorrect = (number == correctAnswer)
//        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        answeredCorrect = nil
    }
}

struct FlagView: View {
    let countryImageName: String
    let onButtonTapped: () -> (Void)
    
    var body: some View {
        Button(action: {
            self.onButtonTapped()
        }) {
            Image(self.countryImageName)
                .renderingMode(.original)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 1))
                .shadow(color: .black, radius: 2)
        }
    }
}

extension View  {
    
    func animateUserResponse(answeredCorrect: Binding<Bool?>, representsCorrectItem: Bool) -> some View {
        self.modifier(FlagViewAnswerAnimationModifier(answeredCorrect: answeredCorrect, representsCorrectItem: representsCorrectItem))
    }
}

struct FlagViewAnswerAnimationModifier: ViewModifier {
    @Binding var answeredCorrect: Bool?
    let representsCorrectItem: Bool
    
    func body(content: Content) -> some View {
        
        guard let answeredCorrect = answeredCorrect else {
            return content
                .scaleEffect(1)
                .opacity(1.0)
                .rotation3DEffect(
                    .degrees(0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                .animation(nil)
        }
        if answeredCorrect {
            if representsCorrectItem {
                return content
                    .scaleEffect(1)
                    .opacity(1.0)
                    .rotation3DEffect(
                        .degrees(360),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                    .animation(.interpolatingSpring(stiffness: 50, damping: 5))
            }
            else {
                return content
                .scaleEffect(1)
                    .opacity(0.25)
                .rotation3DEffect(
                    .degrees(0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                .animation(nil)
            }
        } else {
            if representsCorrectItem {
                return content
                    .scaleEffect(1.25)
                    .opacity(1.0)
                    .rotation3DEffect(
                        .degrees(0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                    .animation(.interpolatingSpring(stiffness: 50, damping: 5))
            }
            else {
                return content
                    .scaleEffect(0.75)
                    .opacity(0.25)
                .rotation3DEffect(
                    .degrees(0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                .animation(nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
