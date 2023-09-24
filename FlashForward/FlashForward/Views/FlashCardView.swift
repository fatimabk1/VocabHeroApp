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
    @State var reviewMode = false
    
    var body: some View {
        var flashCardIndex = tag
        
        NavigationStack {
            VStack {
                VTabView(selection: $tag) {
                    ForEach(0..<topic.flashCards.count, id: \.self){ index in
                        if ((reviewMode && topic.flashCards[index].review) || !reviewMode){
                            VStack{
                                FlashCard(item: topic.flashCards[index])
                                    .tag(topic.flashCards[index].id)
                                    .onAppear() {
                                        flashCardIndex = index
                                    }
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
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                flashcardProgressDisplay(topic: $topic)
                    .padding(.horizontal)
            }
            .navigationTitle("\(topic.name)") // TODO: reduce font size ?
//            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            HStack {
    
                ShuffleButton(topic: $topic, shuffle: $topic.shuffled)
                    .frame(maxWidth: .infinity)
                ReviewButton(review: $topic.flashCards[flashCardIndex].review)
                    .frame(maxWidth: .infinity)
                ReviewModeToggle(topic: $topic, reviewMode: $reviewMode)
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            tag = topic.flashCards.firstIndex(where: {$0.id == topic.mostRecentFlashCard}) ?? 0
        }
    }
}

struct ReviewModeToggle: View {
    @Binding var topic: Topic
    @Binding var reviewMode: Bool
    
    var reviewCount: Int {
        topic.flashCards.filter{$0.review}.count
    }
    
    var body: some View {
        Button {
            if reviewCount > 0 {
                reviewMode.toggle()
            }
        } label: {
            Label("Review", systemImage: "eye")
                .labelStyle(.titleAndIcon)
                .foregroundColor(reviewMode ? .black : .gray)
        }
    }
}

struct ShuffleButton: View {
    @Binding var topic: Topic
    @Binding var shuffle: Bool
    
    var body: some View {
        Button {
            shuffle.toggle()
            if shuffle {
                topic.flashCards.shuffle()
            } else {
                topic.flashCards.sort { $0.orderIndex < $1.orderIndex }
            }
        } label: {
            Label("Shuffle", systemImage: "shuffle")
                .labelStyle(.titleAndIcon)
                .foregroundColor(shuffle ? .black : .gray)
        }
    }
}

struct ReviewButton: View {
    @Binding var review: Bool
    
    var body: some View {
        Button {
            review.toggle()
        } label: {
            Label("Star", systemImage: review ? "star.fill" : "star")
                .labelStyle(.titleAndIcon)
                .foregroundColor(review ? .black : .gray)
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


