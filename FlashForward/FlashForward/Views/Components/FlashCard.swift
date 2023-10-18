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
                    .fill(Color("Theme"))
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(.white, lineWidth: 5)
                    .shadow(color: .black, radius: 10)
                Content(isFaceUp: $isFaceUp, content: item.dictionary)
                    .rotation3DEffect(.degrees(isFaceUp ? 0: 180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
}



struct Content: View {
    @Binding var isFaceUp: Bool
    let content: Dictionary
    
    var body: some View {
        Group {
            if isFaceUp {
                var word = content.word.capitalized(with: .current)
                Text(word)
                    .font(.largeTitle)
                    .foregroundColor(Color("CardText1"))
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                VStack(alignment: .leading){
                    // display first three definitions for now
                    // TODO: FEATURE - user can choose which definitions to add
                    let definitionArray = content.definitions
                    ForEach(0..<3) { index in
                        if index < definitionArray.count {
                            VStack(alignment: .leading) {
                                Text("\(index+1). \(definitionArray[index].definition)")
                                    .font(.body)
                                    .foregroundColor(Color("CardText1"))
                                    .fixedSize(horizontal: false, vertical: true)
                                if let example = definitionArray[index].example {
                                    Text("\"\(example)\"")
                                        .italic()
                                        .font(.callout)
                                        .foregroundColor(Color("CardText2"))
                                        .fixedSize(horizontal: false, vertical: false)
                                }
                                Text("") // space between each definition group
                            }
                        }
                    }
                }
            }
        }
//        .foregroundColor(.white)
        .padding(30)
    }
}


struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCard(item: Topic.sampleTopic.flashCards[4])
    }
}
