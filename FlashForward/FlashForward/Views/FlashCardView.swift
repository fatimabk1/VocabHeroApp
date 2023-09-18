//
//  FlashCardView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI
import VTabView

struct FlashCardView: View {
    @Binding var topic: Topic
    
    var body: some View {
        let flashcards = topic.flashCards
        
        NavigationView {
            VStack{
                VTabView() {
                    ForEach(flashcards){ card in

                        VStack{
                            FlashCard(item: card)
                                .tag(card.id)
                                .onAppear() {
                                    if !card.viewed {
                                        if let c = flashcards.first(where: { $0.id == card.id }) {
                                            c.viewed = true
                                            topic.progress += 1
                                        }
                                    }
                                }
                            Text(card.viewed ? "Previously Viewed" : "New Card!")
                            
                        }
                   }
                }
                .tabViewStyle(PageTabViewStyle())

                ProgressView("Completed \(topic.progress)/\(topic.total)", value: Double(topic.progress / topic.total))
                    .padding(.horizontal)
                Spacer()

            }
            .navigationTitle("\(topic.name)") // TODO: reduce font size
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var manager = TopicManager()
        
        FlashCardView(topic: $manager.topics[0])
            .environmentObject(manager)
    }
}


