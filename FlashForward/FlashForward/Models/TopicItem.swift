//
//  TopicItem.swift
//  FlashForward
//

//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation
import SwiftUI

extension Topic {
    struct TopicItem: Identifiable, Equatable {
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
        
        static func ==(lhs: TopicItem, rhs: TopicItem) -> Bool {
            return lhs.id == rhs.id &&
                    lhs.dictionary == rhs.dictionary &&
                    lhs.viewed == rhs.viewed &&
                    lhs.review == rhs.review &&
                    lhs.orderIndex == rhs.orderIndex
        }
        
        func toStr() -> String {
            return "Topic Item: \(self.dictionary.word)"
        }
        
        mutating func reset() {
            self.viewed = false
            self.review = true
        }
        
    }
}
