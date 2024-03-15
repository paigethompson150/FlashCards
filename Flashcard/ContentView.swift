//
//  ContentView.swift
//  Flashcard
//
//  Created by Paige Thompson on 3/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var deckId: Int = 0
    @State private var cards: [Card] = Card.mockedCards

    @State private var cardsToPractice: [Card] = []
    @State private var cardsMemorized: [Card] = []
    @State private var createCardViewPresented = false
    
    var body: some View {
        
        ZStack {
            
            // Reset buttons
                VStack { // <-- VStack to show buttons arranged vertically behind the cards
                    Button("Reset") {
                       cards = cardsToPractice + cardsMemorized
                       cardsToPractice = []
                       cardsMemorized = []
                       deckId += 1
                   }
                   .disabled(cardsToPractice.isEmpty && cardsMemorized.isEmpty)

                   Button("More Practice") {
                       cards = cardsToPractice
                       cardsToPractice = []
                       deckId += 1
                   }
                   .disabled(cardsToPractice.isEmpty)
               }
            
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(card: cards[index], onSwipedLeft: {
                    let removedCard = cards.remove(at: index)
                    cardsToPractice.append(removedCard)
                }, onSwipedRight: {
                    let removedCard = cards.remove(at: index)
                    cardsMemorized.append(removedCard)
                })
                .rotationEffect(.degrees(Double(cards.count - 1 - index) * -5))
            }
        }
        .animation(.bouncy, value: cards)
        .id(deckId)
        .sheet(isPresented: $createCardViewPresented, content: {
            CreateFlashcardView { card in
                cards.append(card)
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity) 
        .overlay(alignment: .topTrailing) {
            Button("Add Flashcard", systemImage: "plus") {
                createCardViewPresented.toggle()
            }
        }
    }
}


#Preview {
    ContentView()
}
