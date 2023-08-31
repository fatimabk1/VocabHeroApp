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
    @State var text: String?
    @State var image: Image?
    @State var isFaceUp: Bool = false
    
    init(text: String? = nil, image: Image? = nil) {
        self.id = UUID()
        self.text = text
        self.image = image
    }
    
    func flip() {
        self.isFaceUp.toggle()
    }
    
    func reset() {
        self.isFaceUp = false
    }
}

var item = TopicItem(text: "hi", image: Image("cat"))


var topicItemList = [TopicItem(text: "cat", image: Image("cat")),
                     TopicItem(text: "flower", image: Image("flower")),
                     TopicItem(text: "country", image: Image("country")),
                     TopicItem(text: "bird", image: Image("bird")),
                     TopicItem(text: "country", image: Image("country")),
                     TopicItem(text: "flag", image: Image("flag"))]
