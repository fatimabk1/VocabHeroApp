//
//  TopicCard.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct TopicCard: View {
    let topic: Topic
    
    var body: some View {
        VStack{
            topic.image! // Image("cat")
            .resizable()
            .scaledToFill()
            .frame(width: 180, height: 250)
            .cornerRadius(20)
            .shadow(radius: 10)
            .overlay(
                Text("\(topic.name)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .offset(y: -90)
            )
        }
        .frame(width: 180, height: 250)
        
            
        // Swipe Gesture to see edit & delete button
        
    }
}

struct TopicCard_Previews: PreviewProvider {
    static var previews: some View {
//        let catTopic = Topic(name: "North American Cat Breeds", image: Image("cat"))
                          
        TopicCard(topic: topicsList[0])
    }
}
