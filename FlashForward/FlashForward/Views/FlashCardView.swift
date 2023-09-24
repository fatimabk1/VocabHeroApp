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
    @State var tag: Int = 0
    
    var body: some View {
        NavigationView {
            VStack{
                VTabView(selection: $tag) {
                    ForEach(0..<topic.flashCards.count, id: \.self){ index in
                        VStack{
                            FlashCard(item: topic.flashCards[index])
                                .tag(topic.flashCards[index].id)
                                .onDisappear() {
                                    if !topic.flashCards[index].viewed {
                                        topic.flashCards[index].viewed = true
                                        topic.progress += 1
                                    }
                                    topic.mostRecentFlashCard = topic.flashCards[index].id
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
        .onAppear {
            tag = topic.flashCards.firstIndex(where: {$0.id == topic.mostRecentFlashCard}) ?? 0
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


