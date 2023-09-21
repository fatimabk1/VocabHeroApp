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
//        let flashcards = topic.flashCards
        var progress: Double {
            if (topic.total == 0){
                return 0.0
            } else {
                return Double(topic.progress / topic.total)
            }
        }
        
        NavigationView {
            VStack{
                VTabView() {
                    ForEach($topic.flashCards){ $card in
                        VStack{
                            FlashCard(item: card)
                                .tag(card.id)
                                .onAppear() {
                                    card.viewed = true
                                    topic.progress += 1
                                }
                            Text(card.viewed ? "Previously Viewed" : "New Card!")
                            
                        }
                   }
                }
                .tabViewStyle(PageTabViewStyle())
                
                ProgressView("Completed \(topic.progress)/\(topic.total)", value: progress)
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


