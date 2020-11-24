//
//  BookLoaderView.swift
//  SwiftUIAnimations
//
//  Created by Denny Mathew on 23/11/20.
//

import Foundation
import SwiftUI
struct BookLoaderView: View {
    // State vars
    @State private var bookState: LoaderState = .closedRight
    
    // Left Cover
    @State private var leftCoverOffset: CGSize = CGSize(width: widthOffsetLeft, height: 0)
    @State private var leftRotationDegrees: Angle = .zero
    
    // Book holder
    @State private var middleBookOffset: CGSize = CGSize(width: holderHeightOffsetTop, height: holderHeightOffsetTop)
    @State private var middleRotaionDegrees: Angle = .degrees(-90)
    
    // Right cover
    @State private var rightCoverOffset: CGSize = CGSize(width: widthOffsetRight, height: 55.75)
    @State private var rightRotationDegrees: Angle = .degrees(-180)
    
    @State private var currentIndex = 0
    @State private var shouldAnimate = false
    
    // Configurables
    var color: Color = .yellow
    
    // Constants
    let bookCoverWidth: CGFloat = 120
    let animationScale: TimeInterval = 0.4
    
    // Private constants
    fileprivate static let bookCoverHeight: CGFloat = 8
    fileprivate static let bookPagesOffset: CGFloat = -20
    fileprivate static let widthOffsetLeft: CGFloat = -84
    fileprivate static let widthOffsetRight: CGFloat = 84
    fileprivate static let holderHeightOffsetTop: CGFloat = -28
    fileprivate static let holderHeightOffsetBottom: CGFloat = 28
    fileprivate static let heightOffsetTop: CGFloat = -55.75
    fileprivate static let heightOffsetBottom: CGFloat = 55.75
    // Timings
    fileprivate static let bookEndDuration: TimeInterval = 0.9
    fileprivate static let bookEndDelay: TimeInterval = 0.05
    fileprivate static let interStateDuration: TimeInterval = 1.6
    fileprivate static let animateBookInitialDelay: TimeInterval = 3.4
    fileprivate static let repeatDelay: TimeInterval = 5
    // Body
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Capsule()
                .foregroundColor(self.color)
                .frame(width: bookCoverWidth, height: BookLoaderView.bookCoverHeight)
                .offset(leftCoverOffset)
                .rotationEffect(leftRotationDegrees)
            BookHoldView()
                .stroke(style: StrokeStyle(lineWidth: BookLoaderView.bookCoverHeight, lineCap: .round, lineJoin: .miter))
                .foregroundColor(self.color)
                .rotationEffect(middleRotaionDegrees)
                .offset(middleBookOffset)
            Capsule()
                .foregroundColor(self.color)
                .frame(width: bookCoverWidth, height: BookLoaderView.bookCoverHeight)
                .offset(rightCoverOffset)
                .rotationEffect(rightRotationDegrees)
            BookPagesView(shouldAnimate: $shouldAnimate, animationScale: animationScale)
                .offset(y: BookLoaderView.bookPagesOffset)
        }
        .onTapGesture {
            shouldAnimate.toggle()
            animateBookEnds()
            
            Timer.scheduledTimer(withTimeInterval: animationScale * BookLoaderView.animateBookInitialDelay, repeats: false) { _ in
                animateBook()
                
                Timer.scheduledTimer(withTimeInterval: animationScale * BookLoaderView.repeatDelay, repeats: true) { _ in
                    animateBook()
                }
            }
        }
    }
    // Methods
    func getNextCase() -> LoaderState {
        let allCases = LoaderState.allCases
        if self.currentIndex == allCases.count - 1 {
            self.currentIndex = -1
        }
        self.currentIndex += 1
        let index = self.currentIndex
        return allCases[index]
    }
    func animateBook() {
        withAnimation(.linear(duration: animationScale)) {
            middleRotaionDegrees =  bookState.angle(for: .end, part: .holder)
            leftCoverOffset = bookState.offset(for: .end, part: .leftCover)
            rightCoverOffset = bookState.offset(for: .end, part: .rightCover)
        }
        withAnimation(.linear(duration: animationScale)) {
            leftRotationDegrees = bookState.angle(for: .end, part: .leftCover)
            rightRotationDegrees = bookState.angle(for: .end, part: .rightCover)
            middleBookOffset = bookState.offset(for: .end, part: .holder)
        }
        Timer.scheduledTimer(withTimeInterval: animationScale * BookLoaderView.interStateDuration, repeats: false) { _ in
            self.bookState = self.getNextCase()
            self.animateBookEnds()
        }
    }
    func animateBookEnds() {
        // Book Holder
        withAnimation(.easeOut(duration: animationScale)) {
            middleRotaionDegrees = bookState.angle(for: .begin, part: .holder)
            middleBookOffset = bookState.offset(for: .begin, part: .holder)
        }
        withAnimation(.easeOut(duration: animationScale)) {
            leftCoverOffset = bookState.offset(for: .begin, part: .leftCover)
            rightCoverOffset = bookState.offset(for: .begin, part: .rightCover)
        }
        withAnimation(Animation.linear(duration: animationScale * BookLoaderView.bookEndDuration).delay(animationScale * BookLoaderView.bookEndDelay)) {
            leftRotationDegrees = bookState.angle(for: .begin, part: .leftCover)
            rightRotationDegrees = bookState.angle(for: .begin, part: .rightCover)
        }
    }
}
enum LoaderPart {
    case leftCover, rightCover, holder
}
enum AnimationStage {
    case begin, end
}
enum LoaderState: CaseIterable {
    case closedRight, closedLeft
    func offset(for stage: AnimationStage, part: LoaderPart) -> CGSize {
        switch stage {
        case .begin:
            switch self {
            case .closedRight:
                switch part {
                case .leftCover:
                    return CGSize(width: BookLoaderView.widthOffsetLeft, height: 0)
                case .rightCover:
                    return CGSize(width: BookLoaderView.widthOffsetRight, height: 0)
                case .holder:
                    return CGSize(width: 0, height: 0)
                    
                }
            case .closedLeft:
                switch part {
                case .leftCover:
                    return CGSize(width: BookLoaderView.widthOffsetLeft, height: 0)
                case .rightCover:
                    return CGSize(width: BookLoaderView.widthOffsetRight, height: 0)
                case .holder:
                    return CGSize(width: 0, height: 0)
                    
                }
            }
        case .end:
            switch self {
            case .closedRight:
                switch part {
                case .leftCover:
                    return CGSize(width: BookLoaderView.widthOffsetLeft, height: BookLoaderView.heightOffsetBottom)
                case .rightCover:
                    return CGSize(width: BookLoaderView.widthOffsetRight, height: 0)
                case .holder:
                    return CGSize(width: BookLoaderView.holderHeightOffsetBottom, height: BookLoaderView.holderHeightOffsetTop)
                    
                }
            case .closedLeft:
                switch part {
                case .leftCover:
                    return CGSize(width: BookLoaderView.widthOffsetLeft, height: 0)
                case .rightCover:
                    return CGSize(width: BookLoaderView.widthOffsetRight, height: BookLoaderView.heightOffsetBottom)
                case .holder:
                    return CGSize(width: BookLoaderView.holderHeightOffsetTop, height: BookLoaderView.holderHeightOffsetTop)
                }
            }
        }
    }
    func angle(for stage: AnimationStage, part: LoaderPart) -> Angle {
        switch stage {
        case .begin:
            return .zero
        case .end:
            switch self {
            case .closedRight:
                switch part {
                case .leftCover:
                    return .degrees(180)
                case .rightCover:
                    return .zero
                case .holder:
                    return .degrees(90)
                    
                }
            case .closedLeft:
                switch part {
                case .leftCover:
                    return .zero
                case .rightCover:
                    return .degrees(-180)
                case .holder:
                    return .degrees(-90)
                }
            }
        }
    }
}
struct BookLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookLoaderView()
    }
}
