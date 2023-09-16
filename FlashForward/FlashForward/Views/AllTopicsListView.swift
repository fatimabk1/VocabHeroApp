//
//  AllTopicsListView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct AllTopicsListView: View {
    @EnvironmentObject var manager: TopicManager
    @State var multiSelection = false

    var body: some View {
       NavigationView {
            List(manager.getAvailableTopics()){
                Text("\($0.name)")
            }
            .navigationTitle("Learn Something New!")
            .toolbar{
                DoneButton(multiSelection: $multiSelection)
            }
        }
    }
}


struct DoneButton: View {
    @EnvironmentObject var manager: TopicManager
    @Binding var multiSelection: Bool
    @Environment(\.dismiss) private var dismiss
    
//    var multiSelection: Set<UUID>
    
    var body: some View{
        Button{
//            multiSelection.toggle()
            dismiss()
        } label: {
            Image(systemName: multiSelection ? "checkmark.seal.fill" : "seal")
        }
    }
}

struct AllTopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        let model = TopicManager()
        AllTopicsListView()
            .environmentObject(model)
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
