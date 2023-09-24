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
        NavigationView {
            VStack{
                VTabView {
                    ForEach($topic.flashCards){ $card in
                        VStack{
                            FlashCard(item: card)
                                .tag(card.id)
                                .onDisappear() {
                                    if !card.viewed {
                                        card.viewed = true
                                        topic.progress += 1
                                    }
                                }
                        }
                   }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                flashcardProgressDisplay(topic: $topic)
                    .padding(.horizontal)
            }
            .navigationTitle("\(topic.name)") // TODO: reduce font size ?
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct flashcardProgressDisplay: View {
    @Binding var topic: Topic
    
    var body: some View {
        ProgressView(value: topic.progressIndicatorValue) {
            HStack{
                Text("Completed \(topic.progress)/\(topic.total)")
                Spacer()
                Text("\(topic.progressIndicatorValue * 100, specifier: "%.0f")%")
            }
        }
        .tint(.teal)
    }
}

struct FlashCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var manager = TopicManager(makeFlashCards: true)

        FlashCardView(topic: $manager.topics[0])
            .environmentObject(manager)
    }
}


