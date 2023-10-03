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
        self.topics = [Topic.sampleTopic]
    }
    
    func addSet(_ t: Topic) {
        self.topics.append(t)
    }
    
    func removeSet(_ topic: Topic) {
        if let index = self.topics.firstIndex(where: {$0.id == topic.id}){
            self.topics.remove(at: index)
        }
    }
    
    func removeAllSets() {
        for t in topics {
            removeSet(t)
        }
    }

}
