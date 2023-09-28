//
//  AllTopicsListView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct AllTopicsListView: View {
    @EnvironmentObject var manager: TopicManager
    @State private(set) var selections = Set<Topic>()
    @State var savedSelection = false
    @Binding var isPresented: Bool
    
    func updateSelections(topic: Topic){
        if selections.contains(topic) {
           selections.remove(topic)
       } else {
           selections.insert(topic)
       }
    }
    
    var body: some View {
        
       NavigationStack {
           List {
               Section(header: Text("Available Topics"), footer: Text("\(selections.count) topics selected")) {
                   
                   ForEach(manager.topics, id: \.id) { topic in
                       if !topic.added {
                           MultiSelectRow(topic: topic, isSelected: self.selections.contains(topic)) {
                               updateSelections(topic: topic)
                           }
                       }
                   }
                   
               }
           }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    SaveButton(isPresented: $isPresented, selections: $selections)
                }
                ToolbarItem(placement: .cancellationAction) {
                    CancelButton(isPresented: $isPresented)
                }
            }
        }
    }
}

struct SaveButton: View {
    @EnvironmentObject var manager: TopicManager
    @Binding var isPresented: Bool
    @Binding var selections: Set<Topic>
    
    var body: some View{
        Button {
            for selection in selections {
                manager.addSet(selection)
            }
            isPresented = false
        } label: {
            Text("Save")
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
