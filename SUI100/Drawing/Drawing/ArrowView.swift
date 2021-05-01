//
//  ArrowView.swift
//  Drawing
//
//  Created by Hiren Patel on 4/30/21.
//

import SwiftUI


struct ArrowView: InsettableShape {
    
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let pathRect = CGRect(x: rect.minX + insetAmount, y: rect.minY + insetAmount, width: rect.width - insetAmount * 2, height: rect.height - insetAmount * 2)
        
        let triangleHeight = pathRect.height * CGFloat(0.4);
        let arrowWidth = pathRect.width * CGFloat(0.6);
        path.move(to: CGPoint(x: pathRect.midX, y: pathRect.minY))
        path.addLine(to: CGPoint(x: pathRect.minX, y: pathRect.minY + triangleHeight))
        path.addLine(to: CGPoint(x: pathRect.midX - arrowWidth/2, y: pathRect.minY + triangleHeight))
        path.addLine(to: CGPoint(x: pathRect.midX - arrowWidth/2, y: pathRect.maxY))
        path.addLine(to: CGPoint(x: pathRect.midX + arrowWidth/2, y: pathRect.maxY))
        path.addLine(to: CGPoint(x: pathRect.midX + arrowWidth/2, y: pathRect.minY + triangleHeight))
        path.addLine(to: CGPoint(x: pathRect.maxX, y: pathRect.minY + triangleHeight))
        path.addLine(to: CGPoint(x: pathRect.midX, y: pathRect.minY))
        
        return path
   }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arrow = self
        arrow.insetAmount += amount
        return arrow
    }
    
}
