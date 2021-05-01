//
//  ContentView.swift
//  Drawing
//
//  Created by Hiren Patel on 4/15/21.
//

import SwiftUI

struct ContentView: View {
//    @State private var petalOffset = -20.0
//        @State private var petalWidth = 100.0
//
//        var body: some View {
//            VStack {
//                Flower(petalOffset: petalOffset, petalWidth: petalWidth)
//                    .fill(Color.red, style: FillStyle(eoFill: true))
//
//                Text("Offset")
//                Slider(value: $petalOffset, in: -40...40)
//                    .padding([.horizontal, .bottom])
//
//                Text("Width")
//                Slider(value: $petalWidth, in: 0...100)
//                    .padding(.horizontal)
//            }
//        }
    
//    @State private var colorCycle = 0.0
//
//        var body: some View {
//            VStack {
//                ColorCyclingCircle(amount: self.colorCycle)
//                    .frame(width: 300, height: 300)
//
//                Slider(value: $colorCycle)
//            }
//        }
    
//    @State private var amount: CGFloat = 0.0
//
//        var body: some View {
//            VStack {
//                ZStack {
//                    Circle()
//                        .fill(Color.red)
//                        .frame(width: 200 * amount)
//                        .offset(x: -50, y: -80)
//                        .blendMode(.screen)
//
//                    Circle()
//                        .fill(Color.green)
//                        .frame(width: 200 * amount)
//                        .offset(x: 50, y: -80)
//                        .blendMode(.screen)
//
//                    Circle()
//                        .fill(Color.blue)
//                        .frame(width: 200 * amount)
//                        .blendMode(.screen)
//                }
//                .frame(width: 300, height: 300)
//
//                Slider(value: $amount)
//                    .padding()
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.black)
//            .edgesIgnoringSafeArea(.all)
//        }
    
//    @State private var insetAmount: CGFloat = 50
//
//        var body: some View {
//            Trapezoid(insetAmount: insetAmount)
//                .frame(width: 200, height: 100)
//                .onTapGesture {
//                    withAnimation {
//                            self.insetAmount = CGFloat.random(in: 10...90)
//                        }
//                }
//        }
    
//    @State private var rows = 4
//    @State private var columns = 4
//
//    var body: some View {
//        Checkerboard(rows: rows, columns: columns)
//            .onTapGesture {
//                withAnimation(.linear(duration: 3)) {
//                    self.rows = 8
//                    self.columns = 16
//                }
//            }
//    }
    
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                .frame(width: 300, height: 300)

            Spacer()

            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])

                Text("Amount: \(amount, specifier: "%.2f")")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])

                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
            }
        }
    }

}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct Arc: InsettableShape {
    
    var insetAmount: CGFloat = 0
    
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
