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
    
    @State var showingAlert: Bool = false
    
    var count = 0
    var body: some View {

        NavigationView {
            VStack{
                VTabView(selection: $pageIndex) {
                    ForEach(topic.getAllFlashCards()){ item in
                        FlashCard(item: item)
                            .tag(item.id)
                   }
                }
                .onChange(of: pageIndex, perform: { index in
                    // TODO: implement progress update
                })
                .tabViewStyle(PageTabViewStyle())

                Text("Completed \(pageIndex)/\(topic.total)")

            }
            .navigationTitle("\(topic.name)") // TODO: reduce font size
            .toolbar {
                Button("Check Progress") {
                    showingAlert = true
                }
                .alert("Progress: \(pageIndex) / \(topic.total)", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var manager = TopicManager()
        let t = Topic(name: "North American Cat Breeds", emoji: "", makeFlashCards: true)
        
        FlashCardView(topic: t)
            .environmentObject(manager)
    }
}


