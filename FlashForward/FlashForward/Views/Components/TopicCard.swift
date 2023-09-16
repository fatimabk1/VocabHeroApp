//
//  TopicCard.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct TopicCard: View {
    @State var isSelected: Bool = false
    let topic: Topic
    
    var body: some View {
        VStack{
            CardView(isSelected: $isSelected, topic: topic) {
                Text("hi")
            }
        }
    }
}

struct CardView<Content: View>: View {
    @Binding var isSelected: Bool
    let topic: Topic
    var content: () -> Content
    
    var body: some View {
        VStack {
            content()
                .foregroundColor(isSelected ? .gray.opacity(0.8) : .black)
            
            HStack(alignment: .top){
                Spacer()
                Button {
                    isSelected.toggle()
                } label: {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                }
            }
            .padding()
        }
    }
}



struct TopicCard_Previews: PreviewProvider {
    static var previews: some View {
        let catTopic = Topic(name: "North American Cat Breeds", emoji: "", makeFlashCards: true)
                          
        TopicCard(topic: catTopic)
    }
}
//
//VStack{
//                    topic.image! // Image("cat")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 180, height: 250)
//                        .cornerRadius(20)
//                        .shadow(radius: 10)
//                        .overlay(
//                            Text("\(topic.name)")
//                                .foregroundColor(.white)
//                                .fontWeight(.bold)
//                                .padding(8)
//                                .background(Color.black.opacity(0.5))
//                                .cornerRadius(10)
//                                .offset(y: -90)
//                        )
//                }
