//
//  TopicItem.swift
//  FlashForward
//

//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

class TopicItem: Identifiable, ObservableObject {
    let id: UUID
    let front: String?
    let back: String?
    @Published var viewed: Bool
    @Published var tricky: Bool
    
    init(_ front: String? = nil, _ back: String? = nil) {
        self.id = UUID()
        self.front = front
        self.back = back
        self.viewed = false
        self.tricky = false
    }
    
    func markAsViewed() {
        self.viewed = true
    }
    
    func markAsTricky() {
        self.tricky = true
    }
    
    func reset() {
        self.viewed = false
        self.tricky = true
    }

}



var topicItemList = [TopicItem("cat", "a feline creature"),
                     TopicItem("flower", "a blooming plant"),
                     TopicItem("country", "a demarcated area on the globe"),
                     TopicItem("bird", "a flying creature"),
                     TopicItem("flag", "a flying cloth with colors representing a country")]
