//
//  TopicItem.swift
//  FlashForward
//

//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

struct TopicItem: Identifiable {
    let id: UUID
    let front: String?
    let back: String?
    var viewed: Bool
    var review: Bool
    let orderIndex: Int
    
    init(_ front: String? = nil, _ back: String? = nil, order: Int) {
        self.id = UUID()
        self.front = front
        self.back = back
        self.viewed = false
        self.review = false
        self.orderIndex = order
    }
    
    mutating func reset() {
        self.viewed = false
        self.review = true
    }

}



var topicItemList = [TopicItem("cat", "a feline creature", order: 0),
                     TopicItem("flower", "a blooming plant", order: 1),
                     TopicItem("country", "a demarcated area on the globe", order: 2),
                     TopicItem("bird", "a flying creature", order: 3),
                     TopicItem("flag", "a flying cloth with colors representing a country", order: 4)]
