//
//  FlashCardView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI
import VTabView

struct TabItem: Identifiable {
    var id = UUID()
    var title: Text
    var image: Image
    var tag: Int
}

struct FlashCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var topic: Topic
    @State var tag: Int = 0
    @State var reviewMode = false
    @State var reviewProgress = 0 // the index of the current card in the subset of cards for review
    @State var flashCardIndex = 0 // the index of the current card in the full deck shuffled/unshuffled
    
    var body: some View {
        NavigationStack {
            VStack {
                VTabView(selection: $tag) {
                    if reviewMode {
                        let reviewCards = topic.flashCards.filter { $0.review }
                        if reviewCards.count == 0 {
                            ZStack {
                                Image(colorScheme == .dark ? "NothingToReviewDark" : "NothingToReviewLight")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 500)
                                    .offset(x: 70, y: 50)
                                Text("Nothing to review.")
                                    .font(.title)
                                    .padding()
                                    .fixedSize(horizontal: false, vertical: true)
                                    .offset(x: -70, y: -120)
                            }
                        } else {
                            ForEach(0..<reviewCards.count, id: \.self) { index in
                                FlashCard(item: reviewCards[index])
                                    .tag(reviewCards[index].id)
                            }
                            .onAppear(){
                                tag = 0 // reviewMode should always start at the beginning
                            }
                            .onChange(of: tag) { index in
                                flashCardIndex = topic.flashCards.firstIndex(of: reviewCards[index])!
                                reviewProgress = index
                            }
                        }
                    } else {
                        ForEach(0..<topic.total, id: \.self) { index in
                            if (!reviewMode || (reviewMode && topic.flashCards[index].review)){
                                FlashCard(item: topic.flashCards[index])
                                    .tag(topic.flashCards[index].id)
                            }
                        }
                        .onChange(of: tag) { index in
                            // only update resume point in deck during regular modes
                            flashCardIndex = index
                            if topic.shuffled {
                                topic.lastShuffledCard = index
                            } else {
                                topic.lastOrderedCard = index
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                let total = reviewMode ? topic.flashCards.filter({ $0.review}).count : topic.total
                let prog = reviewMode ? reviewProgress : flashCardIndex
                flashcardProgressDisplay(prog: prog, total: total )
                    .padding(.horizontal)
            }
            .navigationTitle("\(topic.name)")
            .navigationBarTitleDisplayMode(.inline)
            HStack {
                ShuffleButton(topic: $topic, tag: $tag, index: flashCardIndex)
                    .frame(maxWidth: .infinity)
                ReviewButton(review: $topic.flashCards[flashCardIndex].review)
                    .frame(maxWidth: .infinity)
                ReviewModeToggle(topic: $topic, reviewMode: $reviewMode)
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            topic.viewedDeck = true
            // resume where we left off in our deck
            tag = topic.shuffled ? topic.lastShuffledCard : topic.lastOrderedCard
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
            reviewMode.toggle()
        } label: {
            Label("Review", systemImage: "eye")
                .labelStyle(.titleAndIcon)
                .foregroundColor(reviewMode ? Color("On") : Color("Off"))
        }
    }
}

struct ShuffleButton: View {
    @Binding var topic: Topic
    @Binding var tag: Int
    let index: Int
    
    var body: some View {
        Button {
            topic.shuffled.toggle()
            if topic.shuffled {
                // shuffle cards and start user from beginning
                topic.lastOrderedCard = index // save where we left off in ordered deck
                topic.flashCards.shuffle()
                tag = 0
            } else {
                // unshuffle cards and start user from last saved card
                topic.flashCards.sort { $0.orderIndex < $1.orderIndex }
                tag = topic.lastOrderedCard // resume ordered deck where we left off
            }
        } label: {
            Label("Shuffle", systemImage: "shuffle")
                .labelStyle(.titleAndIcon)
                .foregroundColor(topic.shuffled ? Color("On") : Color("Off"))
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
                .foregroundColor(review ? Color("On") : Color("Off"))
        }
    }
}

struct flashcardProgressDisplay: View {
    let prog: Int // index of current card
    let total: Int
    
    var body: some View {
        let progressIndicatorValue = Double(prog + 1) / Double(total)
        ProgressView(value: progressIndicatorValue) {
            HStack{
                Text("Completed \(prog + 1)/\(total)")
                Spacer()
                Text("\(progressIndicatorValue * 100, specifier: "%.0f")%")
            }
        }
        .tint(Color("Theme"))
    }
}

struct FlashCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var manager = TopicManager()

        FlashCardView(topic: $manager.topics[0])
            .environmentObject(manager)
    }
}


