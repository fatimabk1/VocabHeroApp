//
//  AllTopicsListView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct AllTopicsListView: View {
    @EnvironmentObject var manager: TopicManager
    @State private(set) var selections: [Topic] = []
    @Binding var isPresented: Bool
    
    var body: some View {
       NavigationView {
           List {
               Section(header: Text("Available Topics"), footer: Text("\(selections.count) topics selected")) {
                   ForEach(manager.getAvailableTopics(), id: \.id) { topic in
                       MultiSelectRow(topicTitle: topic.name, isSelected: self.selections.contains(topic)) {
                           if selections.contains(topic) {
                               selections.removeAll(where: { $0 == topic })
                           } else {
                               selections.append(topic)
                           }
                       }
                   }
               }
           }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) { CancelButton(isPresented: $isPresented)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Spacer()
                }
                ToolbarItem(placement: .navigationBarTrailing) { SaveButton(selections: $selections, isPresented: $isPresented)
                }
            }
        }
    }
}


struct MultiSelectRow: View {
    let topicTitle: String
    var isSelected: Bool
    var action: () -> Void
    
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(topicTitle)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
            .foregroundColor(.primary)
        }

    }
}

struct CancelButton: View {
    @Binding var isPresented: Bool
    var body: some View {
        Button(role: .cancel) {
            isPresented = false
        } label : {
            Text("Cancel")
                .foregroundColor(.red)
        }
    }
}

struct SaveButton: View {
    @EnvironmentObject var manager: TopicManager
    @Binding var selections: [Topic]
    @Binding var isPresented: Bool
    
    var body: some View{
        Button {
            for topic in selections {
                manager.addSet(topic)
            }
            isPresented = false
        } label: {
            Text("Save")
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
