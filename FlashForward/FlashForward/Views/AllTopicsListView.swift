//
//  AllTopicsListView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct AllTopicsListView: View {
    @EnvironmentObject var manager: TopicManager
    
    @State var multiSelection: Bool = false
    @State private var selection = Set<Topic>()
    
    @Binding var isPresented: Bool
    
    var body: some View {
       NavigationView {
           List(manager.getAvailableTopics(), selection: $selection) { topic in
               Text("\(topic.name)")
           }
            .navigationTitle("Learn")
            .toolbar{
                DoneButton(multiSelection: $multiSelection, isPresented: $isPresented)
            }
        }
    }
}


struct DoneButton: View {
    @EnvironmentObject var manager: TopicManager
    @Binding var multiSelection: Bool
    @Binding var isPresented: Bool
    
    // TODO: implement multiselection
//    var multiSelection: Set<UUID>
    
    var body: some View{
        Button{
//            multiSelection.toggle()
            isPresented = false
        } label: {
            Image(systemName: multiSelection ? "checkmark.seal.fill" : "seal")
        }
    }
}

struct AllTopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var manager = TopicManager()
        @State var isPresented = false
        
        AllTopicsListView(isPresented: $isPresented)
            .environmentObject(manager)
    }
}


/*
 ScrollView {
    LazyVGrid(columns: columns){
        ForEach(AllTopicsViewModel.availableTopics){ topic in
            TopicCard(topic: topic)
                .onTapGesture {
                    
                    // add/remove topic from selection
                    if selectedTopics.contains(topic) {
                        selectedTopics.append(topic)
                    } else {
                        if let index = selectedTopics.firstIndex(of: topic) {
                            selectedTopics.remove(at: index)
                        }
                    }
                    
                }
        }
    }.padding()
 }
 */
