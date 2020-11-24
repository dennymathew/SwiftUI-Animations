//
//  BookPagesView.swift
//  SwiftUIAnimations
//
//  Created by Denny Mathew on 23/11/20.
//

import Foundation
import SwiftUI
struct BookPagesView: View {
    // State vars
    @State var didAppear = false
    @State var leftYOffset: CGFloat = 0
    @State var leftEndDegree: Angle = .zero
    @State var rightYOffset: CGFloat = -20
    @State var rightEndDegree: Angle = .zero
    @State var pagesDegree: Angle = .zero
    
    // Binding
    @Binding var shouldAnimate: Bool
    
    // Configurables
    var color = Color.yellow
    
    // Constants
    let bookCoverWidth: CGFloat = 100
    let barOffset: CGFloat = -78
    let animationScale: TimeInterval
    
    // Body
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(self.color)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: barOffset, y: leftYOffset)
                .rotationEffect(leftEndDegree)
                .animation(.easeOut(duration: animationScale))
            Capsule()
                .foregroundColor(self.color)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: barOffset, y: rightYOffset)
                .rotationEffect(rightEndDegree)
                .animation(.easeOut(duration: animationScale))
            // Bars
            ForEach(0..<13) { num in
                Capsule()
                    .foregroundColor(self.color)
                    .frame(width: bookCoverWidth, height: 8)
                    .offset(x: barOffset)
                    .rotationEffect(pagesDegree)
                    .animation(Animation.easeOut(duration: animationScale).delay(animationScale * 0.21 * Double(num)))
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (timer) in
                if shouldAnimate {
                    animatePages()
                    Timer.scheduledTimer(withTimeInterval: animationScale * 10, repeats: true) { _ in
                        animatePages()
                    }
                    timer.invalidate()
                }
            }
        }
    }
    func animatePages() {
        didAppear.toggle()
        
        // Close right
        
        //Right main
        rightEndDegree = .degrees(180)
        rightYOffset = 0
        
        //Pages
        pagesDegree = .degrees(180)
     
        // Left main
        Timer.scheduledTimer(withTimeInterval: animationScale * 2.7, repeats: false) { _ in
            self.leftYOffset = 20
            self.leftEndDegree = .degrees(180)
        }
        
        // Close left

        // Left main
        Timer.scheduledTimer(withTimeInterval: animationScale * 5, repeats: false) { _ in
            self.leftYOffset = 0
            self.leftEndDegree = .zero
        }

        // Pages
        Timer.scheduledTimer(withTimeInterval: animationScale * 5.25, repeats: false) { _ in
            self.pagesDegree = .zero
        }

        // Right main
        Timer.scheduledTimer(withTimeInterval: animationScale * 7, repeats: false) { _ in
            self.rightEndDegree = .zero
            self.rightYOffset = -20
        }
    }
}
struct BookPagesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            BookPagesView(shouldAnimate: .constant(true), animationScale: 0.7)
        }
    }
}
