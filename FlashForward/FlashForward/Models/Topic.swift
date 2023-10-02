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
    private var _progress = 0
    var progress: Int {
        get { return _progress }
        set {
            if newValue > total {
                _progress = total
            } else if newValue < 0 {
                _progress = 0
            } else {
                _progress = newValue
            }
        }
    }

    var progressIndicatorValue: Double {
        if (total == 0){
            return 0
        } else {
            return Double(progress) / Double(total)
        }
    }
    
    var flashCards: [TopicItem]
    var total: Int { self.flashCards.count }
    var mostRecentFlashCard: UUID // TODO: change to computed property by touched timestamp
    var shuffled: Bool

    
    func toStr() -> String {
        var str = "\(emoji) \(name): \(progress) / \(total) completed"
        for card in flashCards {
            str += "\n\t" + "\(card.toStr())"
        }
        return str
    }
    func printTopic() {
        print("Topic \(emoji) \(name): \(progress) / \(total) completed")
        for card in flashCards {
            print("\t" + "\(card.toStr())")
        }
    }
    
    init(name: String = "New Deck", emoji: String = "📚", makeFlashCards: Bool = false){
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.flashCards = []
        self.mostRecentFlashCard = self.id
        self.shuffled = false
        if makeFlashCards {
            for index in 0..<5 {
                addFlashCard(dictionary: Dictionary(word: "\(index + 1)", definitions: [Definition(definition: "def", example: "example")]))
            }
        }
    }
    
    mutating func markCardAsViewed(_ card: TopicItem) {
        if let index = flashCards.firstIndex(where: { $0.id == card.id }){
            if !flashCards[index].viewed {
                flashCards[index].viewed = true
                progress += 1
            }
        }
    }

    mutating func addFlashCard(dictionary: Dictionary) {
        let orderIndexArray = self.flashCards.map { $0.orderIndex }
        let orderIndex = orderIndexArray.max() ?? 0 // TODO: FIX - wrong, should be highest + 1
        let item = Topic.TopicItem(dictionary: dictionary, order: orderIndex)
        self.flashCards.append(item)
    }
    
    mutating func removeFlashCard(_ card: TopicItem) {
        let flashcardIndex = self.flashCards.firstIndex(where: {$0.id == card.id})
        if let flashcardIndex = flashcardIndex {
            if card.viewed {
                self._progress -= 1
            }
            let prevFlashCardIndex = (flashcardIndex - 1) > -1 ? (flashcardIndex - 1) : 0
            self.mostRecentFlashCard = self.flashCards[prevFlashCardIndex].id
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
