//
//  TopicManager.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

class TopicManager: ObservableObject {
    var id = UUID()
    @Published var topics: [Topic]
    
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
        
    func addSet(_ t: Topic) {
        topics.indices.filter{ topics[$0].id == t.id }
            .forEach{ topics[$0].addToLearning() }
    }
    
    func removeSet(_ topic: Topic) {
        if var t = self.topics.first(where: {$0.id == topic.id}){
            t.removeFromLearning()
        }
    }
    
    func removeAllSets() {
        for t in topics {
            removeSet(t)
        }
    }

}
