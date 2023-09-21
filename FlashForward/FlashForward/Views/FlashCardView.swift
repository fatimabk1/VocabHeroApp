//
//  FlashCardView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct FlashCardView: View {
    @Binding var topic: Topic
    
    var body: some View {
        let flashcards = topic.flashCards
        
        NavigationView {
            ScrollView {
                ForEach(flashcards) { card in
                    FlashCard(item: card)
                    
                    // TODO: Confirm below logic works as expected
//                        .tag(card.id)
//                                                       .onAppear() {
//                                                           if !card.viewed {
//                                                               if let c = flashcards.first(where: { $0.id == card.id }) {
//                                                                   c.viewed = true
//                                                                   topic.progress += 1
//                                                               }
//                                                           }
//                                                       }
//                                                   Text(card.viewed ? "Previously Viewed" : "New Card!")
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .navigationTitle("\(topic.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var manager = TopicManager(makeFlashCards: true)
        
        FlashCardView(topic: $manager.topics[0])
            .environmentObject(manager)
    }
}


