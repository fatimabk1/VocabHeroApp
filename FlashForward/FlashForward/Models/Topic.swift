//
//  Topic.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

struct Topic: Identifiable, Equatable, Hashable {
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
    
    init(name: String = "New Deck", emoji: String = "📚", makeFlashCards: Bool = false){
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.flashCards = []
        self.shuffled = false
        if makeFlashCards {
            for index in 0..<5 {
                addFlashCard(dictionary: Dictionary(word: "\(index)", definitions: [Definition(definition: "def", example: "example")]))
            }
        }
    }

    mutating func addFlashCard(dictionary: Dictionary) {
        let orderIndexArray = self.flashCards.map { $0.orderIndex }
        let maxOrderIndex = (orderIndexArray.max() ?? -1)  // TODO: FIX - wrong, should be highest + 1
        let orderIndex = maxOrderIndex + 1
        let item = Topic.TopicItem(dictionary: dictionary, order: orderIndex)
        self.flashCards.append(item)
    }
    
    mutating func removeFlashCard(_ card: TopicItem) {
        let flashcardIndex = self.flashCards.firstIndex(where: {$0.id == card.id})
        if let flashcardIndex = flashcardIndex {
            if flashcardIndex <= lastOrderedCard {
                lastOrderedCard -= 1
            }
            if flashcardIndex <= lastShuffledCard {
                lastShuffledCard -= 1
            }
            self.flashCards.remove(at: flashcardIndex)
        } else {
            print("ERROR: flashcard not found")
            return
        }
    }
    
    static func ==(lhs: Topic, rhs: Topic) -> Bool{
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
