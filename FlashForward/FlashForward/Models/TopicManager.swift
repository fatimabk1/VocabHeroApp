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
    @Published var searchedDictionary: Dictionary
    @Published var isLoading: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case topics, searchedDictionary
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        topics = try values.decodeIfPresent([Topic].self, forKey: .topics) ?? []
        searchedDictionary = try values.decodeIfPresent(Dictionary.self, forKey: .searchedDictionary) ?? Dictionary.defaultDictionary
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topics, forKey: .topics)
        try container.encode(searchedDictionary, forKey: .searchedDictionary)
    }
    
    init() {
        self.topics = []
        searchedDictionary = Dictionary.defaultDictionary
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
