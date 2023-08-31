//
//  FlashCardView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI
import VTabView

struct FlashCardView: View {
    @State var topic: Topic
    
    var body: some View {
        var currentCard = topic.progress
//        let r: Range =
        VStack{
            VTabView {
                ForEach(0..<100){ index in
                    Text("\(index)")
                }
            }
            .background(.green)
            .tabViewStyle(PageTabViewStyle())
                
            
//            if currentCard < topic.total{
//                FlashCard(card: $topic.flashCards[currentCard])
//                    .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
//                        .onEnded({ gesture in
//                            if gesture.translation.width > 0 {
//                                currentCard += 1
//                                topic.progress += 1
//                            } else {
//                                if currentCard > 0{
//                                    currentCard -= 1
//                                }
//                            }
//                        })
//                    )
//            } else {
//                EndFlashCardView()
//            }
            
            Text("Completed \(topic.progress)/\(topic.total)")
        }.navigationTitle("Studying \(topic.name)")
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView(topic: topicsList[1])
    }
}
