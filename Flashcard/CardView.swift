//
//  CardView.swift
//  Flashcard
//
//  Created by Paige Thompson on 3/15/24.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var onSwipedLeft: (() -> Void)? // <-- Add closures to be called when user swipes left or right
    var onSwipedRight: (() -> Void)?
    @State private var isShowingQuestion = true
    @State private var offset: CGSize = .zero
    private let swipeThreshold: Double = 200

    var body: some View {
        
        ZStack {
            
            // Back-most card background
                RoundedRectangle(cornerRadius: 25.0) // <-- Add another card background behind the original
                    .fill(offset.width < 0 ? .red : .green)
            
            // Card background
            RoundedRectangle(cornerRadius: 25.0)
                .fill(isShowingQuestion ? .blue : .indigo)
                .shadow(color: .black, radius: 4, x: -2, y: 2)
                .opacity(1 - abs(offset.width) / swipeThreshold)

            
            VStack {
                // Card type (question vs answer)
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()
                
                // Separator
                Rectangle()
                    .frame(height: 1)
                
                // Card text
                Text(isShowingQuestion ? card.question : card.answer)
            }
            .font(.title)
            .foregroundStyle(.white)
            .padding()
        }
        .frame(width: 300, height: 500)
        .onTapGesture {
            isShowingQuestion.toggle()
        }
        .opacity(3 - abs(offset.width) / swipeThreshold * 3) 
        .rotationEffect(.degrees(offset.width / 20.0))
        .offset(CGSize(width: offset.width, height: 0))
        .gesture(DragGesture()
            .onChanged { gesture in // <-- onChanged called for every gesture value change, like when the drag translation changes
                let translation = gesture.translation // <-- Get the current translation value of the gesture. (CGSize with width and height)
                print(translation) // <-- Print the translation value
            } .onEnded { gesture in  // <-- onEnded called when gesture ends
                
                if gesture.translation.width > swipeThreshold { // <-- Compare the gesture ended translation value to the swipeThreshold
                    print("👉 Swiped right")
                    onSwipedRight?()

                } else if gesture.translation.width < -swipeThreshold {
                    print("👈 Swiped left")
                    onSwipedLeft?()
                } else {
                    print("🚫 Swipe canceled")
                    offset = .zero
                }
            }
        )
    }
}

#Preview {
    CardView(card: Card(question: "q", answer: ""))
}

// Card data model
struct Card: Equatable {
    let question: String
    let answer: String
    
    static let mockedCards = [
        Card(question: "Located at the southern end of Puget Sound, what is the capitol of Washington?", answer: "Olympia"),
        Card(question: "Which city serves as the capital of Texas?", answer: "Austin"),
        Card(question: "What is the capital of New York?", answer: "Albany"),
        Card(question: "Which city is the capital of Florida?", answer: "Tallahassee"),
        Card(question: "What is the capital of Colorado?", answer: "Denver")
    ]
}
