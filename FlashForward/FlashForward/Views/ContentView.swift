//
//  ContentView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    let manager = TopicManager()
    
    var body: some View {
        
        
        TabView {
            AllTopicsListView(topics: topicsList)
                .environmentObject(manager)
                .tabItem{
                    Label("Discover", systemImage: "plus.app")
                }
            CurrentTopicsView()
                .environmentObject(manager)
                .tabItem{
                    Label("Current Learning", systemImage: "house")
                }
            FlashCardView(topic: topicsList[3]) // how to save last studied card?
                .environmentObject(manager)
                .tabItem{
                    Label("Study", systemImage: "rectangle.on.rectangle")
                }
        }
//        .tabViewStyle(.page)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        TopicCard(topic: topicsList[4])
    }
}
