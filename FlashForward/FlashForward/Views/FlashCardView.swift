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
    var reviewCards: [Topic.TopicItem] { topic.flashCards.filter { $0.review } }
    
    var body: some View {
        NavigationStack {
            VStack {
                VTabView(selection: $tag) {
                    if reviewMode {
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
                                VStack {
                                    FlashCard(item: reviewCards[index])
                                        .tag(index)
                                }
                            }
                            .onAppear(){
                                tag = 0 // reviewMode should always start at the beginning
                            }
                            // edge case: ensure that unstarring first review card updates view
                            .onChange(of: reviewCards.count) { count in
                                flashCardIndex = topic.flashCards.firstIndex(of: reviewCards[tag])!
                                reviewProgress = tag
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
                                    .tag(index)
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
                
                let total = reviewMode ? reviewCards.count : topic.total
                let prog = (reviewMode ? reviewProgress : flashCardIndex)
                flashcardProgressDisplay(prog: prog, total: total )
                    .padding(.horizontal)
            }
            .navigationTitle("\(topic.name)")
            .navigationBarTitleDisplayMode(.inline)
            HStack {
                // grab Id to avoid conflict with review vs normal index
                ShuffleButton(topic: $topic, tag: $tag, index: flashCardIndex)
                    .frame(maxWidth: .infinity)
                    .disabled(reviewMode)
                StarButton(review: $topic.flashCards[flashCardIndex].review, reviewMode: reviewMode)
                    .frame(maxWidth: .infinity)
                    .disabled(reviewMode && reviewCards.count == 0) // Disable starring on empty state
                ReviewModeToggle(reviewMode: $reviewMode)
                    .frame(maxWidth: .infinity)
            } . padding(.bottom)
        }
        .onAppear {
            topic.viewedDeck = true
            // resume where we left off in our deck
            tag = topic.shuffled ? topic.lastShuffledCard : topic.lastOrderedCard
        }
    }
}

struct ReviewModeToggle: View {
    @Binding var reviewMode: Bool
    
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
                topic.lastOrderedCard = 0 // return user to start of deck when unshuffling
                // shuffle cards and start user from beginning
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

struct StarButton: View {
    @Binding var review: Bool
    let reviewMode: Bool
    
    var body: some View {
        Button {
            // Don't allow adding non-visible cards while in review mode
            if (reviewMode && review == true) || !reviewMode {
                review.toggle()
            }
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
    
    func calculateProgress(prog: Int, total: Int) -> Double {
        var progressIndicatorValue = 0.0
        if prog == total {
            // catches issue where reviewProgress does not update fast enough when a card is unstarred. Total is correct but prog is one ahead.
            progressIndicatorValue = 1.0
        } else if total != 0 {
            progressIndicatorValue = Double(prog + 1) / Double(total)
        }
        return progressIndicatorValue
    }

    var body: some View {
        let progressIndicatorValue = calculateProgress(prog: prog, total: total)
        ProgressView(value: progressIndicatorValue) {
            HStack {
                if total != 0 {
                    Text("Completed \(prog + 1)/\(total)")
                    Spacer()
                    Text("\(progressIndicatorValue * 100, specifier: "%.0f")%")
                }
            }
        }
        .tint(Color("ThemeAccent"))
    }
}

struct FlashCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var manager = TopicManager()

        FlashCardView(topic: $manager.topics[0])
            .environmentObject(manager)
    }
}


