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
    private let allTopics: [Topic] = topicsList
    var currentTopics: [Topic] = []
    
    // init function creating the set of available topics Topic() from JSON file
    
    func addSet(_ topic: Topic){
        currentTopics.append(topic)
        topic.createFlashCards()
    }
    
    func removeSet(_ topic: Topic){
        if let index = currentTopics.firstIndex(of: topic) {
            currentTopics.remove(at: index)
        }
        topic.deleteFlashCards()
    }
    
    func removeAllSets(){
        for t in currentTopics {
            t.deleteFlashCards()
        }
        currentTopics = []
    }
    
    func getAvailableTopics() -> [Topic]{
        // TODO: return allTopics - currentTopics
        return allTopics
    }
    
    
    
}

var topicsList = [Topic(name: "North American Cat Breeds", emoji: ""),
                  Topic(name: "Summer Blooms", emoji: ""),
                  Topic(name: "Tropical Birds", emoji: ""),
                  Topic(name: "Flags Around the World", emoji: ""),
                  Topic(name: "Countries Around the Globe", emoji: "")]


