//
//  TopicManager.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

class TopicManager: ObservableObject {
    private var id = UUID()
    // TODO:  make allTopics and currentTopics sets
    @Published /*private*/ var topics: [Topic]
    var currentTopics: [Topic] { topics.filter { $0.added } }
    var availableTopics: [Topic] { topics.filter { !$0.added } }
    
    init() {
        self.topics = [Topic(name: "North American Cat Breeds", emoji: "🐈‍⬛"),
                       Topic(name: "Summer Blooms", emoji: "🌸"),
                       Topic(name: "Tropical Birds", emoji: "🦜"),
                       Topic(name: "Flags Around the World", emoji: "🇺🇸"),
                       Topic(name: "Countries Around the Globe", emoji: "🌍")]
    }
    
    init(makeFlashCards: Bool = false) {
        if makeFlashCards {
            self.topics = [Topic(name: "North American Cat Breeds", emoji: "🐈‍⬛", makeFlashCards: true),
                           Topic(name: "Summer Blooms", emoji: "🌸", makeFlashCards: true),
                           Topic(name: "Tropical Birds", emoji: "🦜", makeFlashCards: true),
                           Topic(name: "Flags Around the World", emoji: "🇺🇸", makeFlashCards: true),
                           Topic(name: "Countries Around the Globe", emoji: "🌍", makeFlashCards: true)]
        } else {
            self.topics = []
        }
    }
    
    // TODO: init function creating the set of available topics Topic() from JSON file
    
    func addSet(_ t: Topic) {
        t.added = true
        t.createFlashCards()
    }
    
    func removeSet(_ t: Topic) {
        t.added = false
        t.deleteFlashCards()
    }
    
    func removeAllSets() {
        for t in topics {
            removeSet(t)
        }
    }
    
    func getAvailableTopics() -> [Topic] {
        return topics.filter { !$0.added }
    }
    
    func getCurrentTopics() -> [Topic] {
        return topics.filter { $0.added }
    }
    
}
