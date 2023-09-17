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
    private var topics: [Topic] = topicsList
    
    
    /*
     // topic lists needed:
     - available topics (topic.learning == true )
     - started topics (topic.learning == true && topic.progress == 0)
     
     // flash card (topic item) lists needed:
     - viewed
     - tricky
     
     
     --> flash card reset / remove --> reset progress, viewed, and tricky
     */
    
    
    // init function creating the set of available topics Topic() from JSON file
    
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

var topicsList = [Topic(name: "North American Cat Breeds", emoji: ""),
                  Topic(name: "Summer Blooms", emoji: ""),
                  Topic(name: "Tropical Birds", emoji: ""),
                  Topic(name: "Flags Around the World", emoji: ""),
                  Topic(name: "Countries Around the Globe", emoji: "")]


