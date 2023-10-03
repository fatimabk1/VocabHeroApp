//
//  FlashCard.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct FlashCard: View {
    let item: Topic.TopicItem
    
    @State var isFaceUp: Bool = true
    @State var cardRotation: Double = 0.0

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
    let item: Topic.TopicItem
    
    var body: some View  {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.teal)
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.white, lineWidth: 5)
                    .shadow(color: .black, radius: 10)
                Content(isFaceUp: $isFaceUp, content: item.dictionary)
                    .rotation3DEffect(.degrees(isFaceUp ? 0: 180), axis: (x: 0, y: 1, z: 0))
            }
            Text("Order: \(item.orderIndex)")
        }
    }
}

struct Content: View {
    @Binding var isFaceUp: Bool
    let content: Dictionary
    
    var body: some View {
        Group {
            if isFaceUp {
                Text(content.word)
            } else {
                VStack(alignment: .leading){
                    Text(content.word)
                        .font(.headline)
                    let definitionArray = content.definitions
                    ForEach(definitionArray.indices, id: \.self) { index in
                        Text("\(index+1). \(definitionArray[index].definition)")
                        if let example = definitionArray[index].example {
                            Text("\"\(example)\"")
                                .italic()
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .foregroundColor(.white)
        .font(.title)
        .padding(30)
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var manager = TopicManager()
        FlashCard(item: manager.topics[0].flashCards[0])
    }
}
