//
//  Day46-Wrapup.swift
//  Drawing
//
//  Created by Hiren Patel on 4/30/21.
//

import SwiftUI

struct Day46WrapupView: View {
    
    @State private var strokeWidth = CGFloat(2)
    @State private var animatableStrokeWidth = CGFloat(2)
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
        ArrowView(insetAmount: 0)
            .strokeBorder(Color.purple, style: StrokeStyle(lineWidth: animatableStrokeWidth, lineCap: .round, lineJoin: .round))
            .frame(width: 200, height: 100)
            Slider(value: $strokeWidth, in: 1...10)
                .onChange(of: self.strokeWidth) { newValue in
                    withAnimation {
                        self.animatableStrokeWidth = newValue
                    }
                }
                .padding([.horizontal, .bottom])
            
            ColorCyclingRectangle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
                .padding([.horizontal, .bottom])
        }
    }
    
}
