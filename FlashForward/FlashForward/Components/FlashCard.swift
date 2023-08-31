//
//  FlashCard.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct FlashCard: View {
    @Binding var card: TopicItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.blue)
            if card.isFaceUp {
//                card.image
                Text("bllllla")
            } else {
                Text(card.text ?? "empty")
                    .font(.title)
            }
        }
        .onTapGesture {
            card.flip()
        }
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        let item = TopicItem(text: "cat", image: Image("cat"))
        FlashCard(card: Binding.constant(item))
    }
}
