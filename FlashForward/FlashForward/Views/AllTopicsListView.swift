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
    
    func updateSelections(topic: Topic){
        if selections.contains(topic) {
           selections.removeAll(where: { $0 == topic })
       } else {
           selections.append(topic)
       }
    }
    
    var body: some View {
       NavigationView {
           List {
               Section(header: Text("Available Topics"), footer: Text("\(selections.count) topics selected")) {
                   ForEach(manager.availableTopics, id: \.id) { topic in
                       MultiSelectRow(topic: topic, isSelected: self.selections.contains(topic)) {
                           updateSelections(topic: topic)
                       }
                   }
               }
           }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { CancelButton(isPresented: $isPresented) }
                ToolbarItem(placement: .navigationBarLeading) { Spacer() }
                ToolbarItem(placement: .navigationBarTrailing) { SaveButton(isPresented: $isPresented, selections: $selections) }
            }
        }
    }
}

struct SaveButton: View {
    @EnvironmentObject var manager: TopicManager
    @Binding var isPresented: Bool
    @Binding var selections: [Topic]
    
    var body: some View{
        HStack{
//            Button {
//                isPresented = false
//            } label: {
//                Text(selections[0].added ? "Selections added" : "NO change")
//            }
            
            // Save Button
            Button {
//                var topicsToAdd = Set(manager.topics).intersection(Set(selections))
//                for topic in topicsToAdd{
//                    manager.topics.filter({$0.id == topic.id})[0].added = true
//                }
                for topic in selections {
                    manager.addSet(topic)
                }
                isPresented = false
            } label: {
                Text("Save")
            }
        }
    }
}

struct MultiSelectRow: View {
    let topic: Topic
    var isSelected: Bool
    var action: () -> Void
    
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                if let emoji = topic.emoji {
                    Text(emoji)
                }
                Text(topic.name)
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

struct AllTopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var manager = TopicManager()
        @State var isPresented = false
        
        AllTopicsListView(isPresented: $isPresented)
            .environmentObject(manager)
    }
}
