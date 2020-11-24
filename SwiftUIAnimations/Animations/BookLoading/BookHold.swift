//
//  BookHold.swift
//  SwiftUIAnimations
//
//  Created by Denny Mathew on 23/11/20.
//

import Foundation
import SwiftUI
struct BookHoldView: Shape {
    // MARK: - Methods
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX - 28
        let cY: CGFloat = rect.midY
        
        var path = Path()
        path.move(to: CGPoint(x: cX, y: cY))
        path.addLine(to: CGPoint(x: cX, y: cY + 12))
        path.addLine(to: CGPoint(x: cX + 56, y: cY + 12))
        path.addLine(to: CGPoint(x: cX + 56, y: cY))
        return path
    }
}
struct BookHold_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            BookHoldView()
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .miter))
                .foregroundColor(.white)
            Capsule()
                .frame(width: 5)
                .foregroundColor(.white)
        }
    }
}
