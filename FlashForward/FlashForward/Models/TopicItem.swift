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
    let dictionary: Dictionary
    var viewed: Bool
    var review: Bool
    let orderIndex: Int
    
    init(dictionary: Dictionary, order: Int) {
        self.id = UUID()
        self.dictionary = dictionary
        self.viewed = false
        self.review = false
        self.orderIndex = order
    }
    
    mutating func reset() {
        self.viewed = false
        self.review = true
    }

}
