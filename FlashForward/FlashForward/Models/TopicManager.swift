//
//  TopicManager.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

class TopicManager: Identifiable, ObservableObject, Codable {
    let id = UUID()
    @Published var topics: [Topic]
    
    enum CodingKeys: String, CodingKey {
        case topics
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        topics = try values.decode([Topic].self, forKey: .topics)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topics, forKey: .topics)
    }
    
    init() {
        self.topics = []
//        self.topics = [Topic.sampleTopic]
    }
    
    func addSet(_ t: Topic) {
        self.topics.append(t)
    }
    
    func removeSet(_ topic: Topic) {
        if let index = self.topics.firstIndex(where: {$0.id == topic.id}){
            self.topics.remove(at: index)
        }
    }

}
