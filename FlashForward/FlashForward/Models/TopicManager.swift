//
//  TopicManager.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

class TopicManager: ObservableObject {
    var id: UUID
    @Published var topics: [Topic] = []
    
    init(){
        id = UUID()
//        topics = topicsList
    }
    
    func add(topic: Topic){
        if !topics.contains(topic){
            topics.append(topic)
        }
    }
    
    func remove(topic: Topic){
        if let index = topics.firstIndex(of: topic) {
            topics.remove(at: index)
        }
    }
    
    func clear(){
        topics = []
    }
}

var topicsList = [Topic(name: "North American Cat Breeds", image: Image("cat")),
                  Topic(name: "Summer Blooms", image: Image("flower")),
                  Topic(name: "Tropical Birds", image: Image("bird")),
                  Topic(name: "Flags Around the World", image: Image("flag")),
                  Topic(name: "Countries Around the Globe", image: Image("country"))]


