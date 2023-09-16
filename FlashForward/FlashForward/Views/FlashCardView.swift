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
    @State private var pageIndex = 0
    
    var count = 0
    var body: some View {

        VStack{
            VTabView(selection: $pageIndex) {
                ForEach(topic.flashCards){ item in
                    FlashCard(item: item)
                        .tag(item.id)
               }
            }
            .onChange(of: pageIndex) { newValue in
                
            }
            .tabViewStyle(PageTabViewStyle())

            Text("Completed \(topic.progress)/\(topic.total)")

        }.navigationTitle("Studying \(topic.name)")
    }
}

struct FlashCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let manager = TopicManager()
        let t = Topic(name: "North American Cat Breeds", emoji: "", makeFlashCards: true)
        
        FlashCardView(topic: t)
            .environmentObject(manager)
    }
}


