//
//  TopicItem.swift
//  FlashForward
//

//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

struct TopicItem: Identifiable {
    var id: UUID
    var front: String?
    var back: String?
    
    init(_ front: String? = nil, _ back: String? = nil) {
        self.id = UUID()
        self.front = front
        self.back = back
    }
}



var topicItemList = [TopicItem("cat", "a feline creature"),
                     TopicItem("flower", "a blooming plant"),
                     TopicItem("country", "a demarcated area on the globe"),
                     TopicItem("bird", "a flying creature"),
                     TopicItem("flag", "a flying cloth with colors representing a country")]
