//
//  Topic.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

struct Topic: Identifiable, Equatable {
    // topic details
    var id: UUID
    var name: String
    var emoji: String
    
    // set details
    var viewedDeck = false // tracks whether or not we've started the deck
    var flashCards: [TopicItem]
    var total: Int { self.flashCards.count }
    var lastShuffledCard: Int = 0
    var lastOrderedCard: Int = 0
    var shuffled: Bool

    func toStr() -> String {
        var str = "\(emoji) \(name): \(lastOrderedCard) / \(total) completed"
        for card in flashCards {
            str += "\n\t" + "\(card.toStr())"
        }
        return str
    }
    func printTopic() {
        print("Topic \(emoji) \(name): \(lastOrderedCard) / \(total) completed")
        for card in flashCards {
            print("\t" + "\(card.toStr())")
        }
    }
    
    init(name: String = "New Deck", emoji: String = "📚", flashcards: [Topic.TopicItem]? = nil){
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.flashCards = []
        self.shuffled = false
        if let flashcards = flashcards {
            self.flashCards = flashcards
        }
    }

    mutating func addFlashCard(dictionary: Dictionary) {
        let orderIndexArray = self.flashCards.map { $0.orderIndex }
        let maxOrderIndex = (orderIndexArray.max() ?? -1)
        let orderIndex = maxOrderIndex + 1
        let item = Topic.TopicItem(dictionary: dictionary, order: orderIndex)
        self.flashCards.append(item)
    }
    
//    static func ==(lhs: Topic, rhs: Topic) -> Bool{
//        return lhs.id == rhs.id
//    }
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    
}


extension Topic {
    static var vocabDictionaries = [
    Dictionary(word: "Ephemeral", definitions: [
        Definition(definition: "Lasting for a very short time; transient or fleeting.", example: "The beauty of the cherry blossoms is ephemeral.")
    ]),
    Dictionary(word: "Nefarious", definitions: [
        Definition(definition: "Wicked, villainous, or infamous for being extremely evil.", example: "The nefarious villain plotted to take over the city."),
        Definition(definition: "Involving or characterized by evil intentions or actions.", example: "The nefarious deeds of the criminal organization shocked the community.")
    ]),
    Dictionary(word: "Quixotic", definitions: [
        Definition(definition: "Exceedingly idealistic, unrealistic, and impractical, often in a grandiose or visionary way.", example: "His quixotic quest for world peace inspired many but seemed unattainable."),
        Definition(definition: "Fanciful or impractical in a way that is unrealistic or impossible.", example: "Her quixotic dreams of becoming a famous astronaut drove her to pursue a career in science.")
    ]),
    Dictionary(word: "Lethargic", definitions: [
        Definition(definition: "Lacking in energy, enthusiasm, or motivation; sluggish or apathetic.", example: "After a long day at work, he felt lethargic and unmotivated."),
        Definition(definition: "Reluctant to move or engage in activity due to tiredness or laziness.", example: "The heat made the travelers feel lethargic, and they took a long nap."),
        Definition(definition: "Feeling drowsy or sleepy, often due to fatigue.", example: "The medication made her feel lethargic and unable to concentrate."),
        Definition(definition: "Showing a lack of interest or enthusiasm; apathetic.", example: "His lethargic response to the exciting news surprised everyone.")
    ]),
    Dictionary(word: "Serendipity", definitions: [
        Definition(definition: "The occurrence of fortunate events by chance in a happy or beneficial way.", example: "Their meeting was a serendipity, leading to a lifelong friendship."),
        Definition(definition: "A fortunate and unexpected discovery or realization.", example: "The serendipity of finding a rare book in the used bookstore brought joy to the collector."),
        Definition(definition: "Luck or fate that brings about delightful and unexpected discoveries or experiences.", example: "The serendipity of stumbling upon a beautiful beach during their road trip made the journey memorable."),
        Definition(definition: "The faculty of making fortunate discoveries by accident.", example: "Her serendipity in finding unique vintage clothing at thrift stores was legendary among her friends."),
        Definition(definition: "The phenomenon of finding valuable or agreeable things not sought for.", example: "The serendipity of discovering a hidden talent for painting changed her life.")
    ])
    ]
    
    static var sampleTopic = FlashForward.Topic(name: "Recently Read", emoji: "🐥", flashcards:
        [Topic.TopicItem(dictionary: vocabDictionaries[0], order: 0),
        Topic.TopicItem(dictionary: vocabDictionaries[1], order: 1),
        Topic.TopicItem(dictionary: vocabDictionaries[2], order: 2),
        Topic.TopicItem(dictionary: vocabDictionaries[3], order: 3),
        Topic.TopicItem(dictionary: vocabDictionaries[4], order: 4)])
}
