//
//  ContentView.swift
//  RockPaperSicssors
//
//  Created by Hiren Patel on 4/6/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var moves = ["🪨 Rock", "📃 Paper", "⚔️ Sicssors"]
    @State private var pick: Int = Int.random(in: 0...2)
    @State private var shouldWin: Bool = Bool.random()
    @State private var score: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Score: \(self.score)")
                .scoreStyle()
            HStack(spacing: 20) {
                VStack(spacing: 20) {
                    Text("Move")
                        .headerStyle()
                    Text("\(self.moves[pick])")
                }
                VStack(spacing: 20) {
                    Text("Win")
                        .headerStyle()
                    if self.shouldWin {
                        Text("Yes")
                    }
                    else {
                        Text("No")
                    }
                }
            }
            .padding()
            HStack(spacing: 10) {
                ForEach(0..<moves.count) {number in
                    ButtonView(moveName: moves[number]) {
                        self.processMove(selection: number)
                    }
                }
            }
        }
    }
    
    private func processMove(selection: Int) {
        let correctResponse: Int
        if self.shouldWin {
            if pick < 2 {
                correctResponse = pick + 1
            } else {
                correctResponse = 0
            }
        } else {
            if pick > 0 {
                correctResponse = pick - 1
            } else {
                correctResponse = 2
            }
        }
        
        if correctResponse == selection {
            score += 1
        } else {
            score -= 1
        }
        
        askQuestion()
    }
    
    private func askQuestion() {
        pick = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

struct ScoreStyleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.blue)
            .padding()
    }
}

struct HeaderStyleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
    }
}

extension View {
    
    func scoreStyle() -> some View {
        self.modifier(ScoreStyleModifier())
    }
    
    func headerStyle() -> some View {
        self.modifier(HeaderStyleModifier())
    }
    
}

struct ButtonView: View {
    let moveName: String
    let onButtonTapped: () -> (Void)
    
    var body: some View {
        Button(action: {
            self.onButtonTapped()
        }) {
            Button(action: {
                self.onButtonTapped()
            }) {
                Text(moveName)
                    .padding()
                    .foregroundColor(.white)
            }
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
            .shadow(color: .blue, radius: 2)
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
