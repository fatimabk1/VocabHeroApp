//
//  Topic.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import Foundation

struct Topic: Identifiable {
    var id = UUID()
    var name: String
    var progress = 0
    var totalCards = 0
//    var description: String?
//    var flashCards = [FlashCard]
    
}

var topicList = [Topic(name: "Birds"), Topic(name: "Cats"), Topic(name: "Countries"), Topic(name: "Flowers")]
