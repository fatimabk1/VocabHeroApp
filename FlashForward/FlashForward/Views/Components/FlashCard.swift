//
//  FlashCard.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct FlashCard: View {
    let item: TopicItem
    
    @State var isFaceUp: Bool = true
    @State var cardRotation: Double = 0.0
    
//    @Binding varcard: TopicItem

    var body: some View {
        ZStack {
            Card(isFaceUp: $isFaceUp, item: item)
                .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: -1, z: 0))
        }
        .padding(30)
        .onTapGesture {
            flipFlashCard()
        }
    }
    
    func flipFlashCard(){
        let animationDuration = 0.3
        
        withAnimation(.linear(duration: animationDuration)) {
            cardRotation = (cardRotation > 0) ? 0 : 180
        }
        
        withAnimation(.linear(duration: 0.001).delay(animationDuration / 2)){
            isFaceUp.toggle()
        }
    }

}

struct Card: View {
    @Binding var isFaceUp: Bool
    let item: TopicItem
    
    var body: some View  {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.teal)
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white, lineWidth: 5)
                .shadow(color: .black, radius: 10)
            Content(isFaceUp ? item.front : item.back)
                .rotation3DEffect(.degrees(isFaceUp ? 0: 180), axis: (x: 0, y: 1, z: 0))
        }
    }
}

struct Content: View {
    let content: String?
    
    init(_ content: String?){
        self.content = content
    }
    
    var body: some View {
        if let txt = content {
            Text(txt)
                .foregroundColor(.white)
                .font(.title)
                .padding(30)
        }
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        let item = TopicItem("dog", "a furry and barking animal")
        FlashCard(item: item)
    }
}
