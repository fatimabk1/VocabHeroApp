//
//  SearchView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 10/6/23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State var searchTerm = ""
    @State var failedSearchTerm: String? = nil
    @State var deckSelectionIsPresented = false
    @State var newTopic: Topic = Topic()
    @State var newEditIsPresented = false
    
    var body: some View {
        NavigationStack {
            SearchBar(text: $searchTerm)
                .padding()
                .onSubmit {
                    failedSearchTerm = nil
                    searchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                    let currentWord = searchTerm
                    Task {
                        do {
                            if currentWord != "" {
                                manager.searchedDictionary = try await fetchDictionary(word: currentWord)
                            }
                            searchTerm = ""
                        } catch {
                            failedSearchTerm = currentWord
                        }
                    }
                }
            if let failedSearchTerm = failedSearchTerm {
                Text("No results for \"\(failedSearchTerm)\".")
                    .font(.callout)
                    .foregroundColor(Color("Text2"))
                ZStack {
                    Image(colorScheme == .dark ? "NoResultsDark" : "NoResultsLight")
                        .resizable()
                        .frame(width: 500)
                        .offset(x: 70, y: 50)
                    Text("No results found.")
                        .font(.title)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        .offset(x: -50, y: -160)
                }
                Spacer()
            } else {
                let searchedDictionary = manager.searchedDictionary
                VStack(alignment: .leading) {
                    HStack {
                        Text(searchedDictionary.word.capitalized(with: .current))
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        Text(newTopic.toStr()).hidden() // Hack to ensure that sheet value updates on first click
                            .frame(width: 1, height: 1)
                        Spacer()
                        Button("Add to Deck") {
                            if manager.topics.count > 0 {
                                deckSelectionIsPresented = true
                            } else {
                                var t = Topic()
                                t.addFlashCard(dictionary: searchedDictionary)
                                newTopic = t
                                newEditIsPresented = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("ThemeAccent"))
                        .sheet(isPresented: $deckSelectionIsPresented) {
                            MultiSelectAddToDeck(dictionary: searchedDictionary)
                        }
                        .sheet(isPresented: $newEditIsPresented) { /* [newTopic] in */
                            EditDeckView(topic: $newTopic, isPresented: $newEditIsPresented, isNewTopic: true)
                        }
                    }
                    Divider()
                    ScrollView {
                        VStack(alignment: .leading) {
                            let definitions = searchedDictionary.definitions
                            ForEach(definitions.indices, id: \.self) { index in
                                Text("\(index + 1). \(definitions[index].definition)")
                                    .foregroundStyle(Color("Text1"))
                                    .font(.body)
                                if let example = definitions[index].example {
                                    Text("\"\(example)\"")
                                        .foregroundStyle(Color("Text2"))
                                        .font(.callout)
                                        .italic()
                                }
                                Divider()
                            }
                        }
                        .padding()
                    }
                }
                .textSelection(.enabled)
                .padding(.horizontal)
            }
        }
    }
}

struct MultiSelectAddToDeck: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.dismiss) var dismiss
    let dictionary: Dictionary
    @State var selected = Set<Topic>()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($manager.topics) { $topic in
                    MultiSelectRow(topic: $topic, isSelected: selected.contains(topic))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selected.contains(topic) {
                                selected.remove(topic)
                            } else {
                                selected.insert(topic)
                            }
                        }
                }
            }
            .navigationTitle("Add \"\(dictionary.word.capitalized)\"")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                    .tint(.red)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        for topic in selected {
                            if let index = manager.topics.firstIndex(of: topic) {
                                manager.topics[index].addFlashCard(dictionary: dictionary)
                            }
                            dismiss()
                        }
                    }
                    .tint(.blue)
                }
            }
        }
    }
}

struct MultiSelectRow: View {
    @Binding var topic: Topic
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text("\(topic.emoji) \(topic.name)")
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
    }
}

// SearchBar sourced from https://www.appcoda.com/swiftui-search-bar/
struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                    }
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .tint(.blue)
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var store = Store()
        
        SearchView()
        .environmentObject(store.manager)
        .task {
            do {
                try await store.load()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
