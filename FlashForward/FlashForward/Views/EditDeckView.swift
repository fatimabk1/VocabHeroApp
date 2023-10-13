//
//  EditDeckView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 10/11/23.
//

import SwiftUI

// takes a topic to edit
// passed topic is a copy of existing or a new topic
struct Config {
    var name = ""
    var emoji = ""
    var viewedDeck = false
    var flashcards: [Topic.TopicItem] = []
    var lastOrderedCard = 0
    var lastShuffledCard = 0
    var additions: [Dictionary] = []
    var nextCardIndex: Int {
        let orderIndexArray = flashcards.map { $0.orderIndex }
        let maxOrderIndex = (orderIndexArray.max() ?? -1)
        let orderIndex = maxOrderIndex + 1
        return orderIndex
    }
    
    init(topic: Topic? = nil) {
        let baseTopic = topic ?? Topic()
        name = baseTopic.name
        emoji = baseTopic.emoji
        viewedDeck = baseTopic.viewedDeck
        lastOrderedCard = baseTopic.lastOrderedCard
        lastShuffledCard = baseTopic.lastOrderedCard
        flashcards = baseTopic.flashCards
    }
    
    mutating func removeFlashCard(at index: Int) {
        if index <= lastOrderedCard {
            if lastOrderedCard == 0 {
                viewedDeck = false
            } else {
                lastOrderedCard = lastOrderedCard - 1
            }
        }
        if index <= lastShuffledCard {
             if lastShuffledCard == 0 {
                viewedDeck = false
            } else {
                lastShuffledCard = lastShuffledCard - 1
            }
        }
        self.flashcards.remove(at: index)
    }
    
    func toStr() -> String {
        var text = "\(emoji) \(name):"
        for card in flashcards {
            text += "\n \(card.toStr())"
        }
        return text
    }
}

struct AlertInfo: Identifiable {
    enum AlertType {
        case emptyDeck, emptyTitle, emptyEmoji
    }

    let id: AlertType
    let title: String
    let message: String
}

struct EditDeckView: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.dismiss) var dismiss
    
    // received from above
    @Binding var topic: Topic
    @Binding var isPresented: Bool
    let isNewTopic: Bool
    
    // local to view
    @State var config: Config
    @State var additions: [Dictionary] = []
    @State var newTopic = Topic()
    @State var invalidConfigAlert = false
    @State var alert: AlertInfo? = nil // hold which alert we need to display
    @State private var info: AlertInfo?
        
    init(topic: Binding<Topic>, isPresented: Binding<Bool>, isNewTopic: Bool) {
        _topic = topic
        _config = State(initialValue: Config(topic: topic.wrappedValue))
        _isPresented = isPresented
        self.isNewTopic = isNewTopic
    }
    
    func saveConfig(topic: inout Topic, config: inout Config, isNewTopic: Bool){
        topic.name = config.name
        topic.emoji = (config.emoji == "") ? "" : config.emoji
        topic.viewedDeck = config.viewedDeck
        topic.lastOrderedCard = config.lastOrderedCard
        topic.lastShuffledCard = config.lastShuffledCard
        topic.flashCards = config.flashcards
        
        if isNewTopic {
            manager.addSet(topic)
        }
    }
    
    var body: some View {
        let _ = topic
        NavigationStack {
            Form {
                Section("Title") {
                    HStack {
                        Text("Deck Name: ")
                            .fontWeight(.semibold)
                        let name = config.name
                        TextField(name, text: $config.name)
                    }
                    HStack {
                        Text("Deck Emoji: ")
                            .fontWeight(.semibold)
                        let emoji = config.emoji
                        TextField(emoji, text: $config.emoji)
                        .onChange(of: config.emoji) { _ in
                            config.emoji = String(config.emoji.prefix(1))
                        }
                    }
                }
                List {
                    Section("Flashcards") {
                        AddCardRow(config: $config)
                        ForEach($config.flashcards) { $card in
                            EditDeckListRow(dictionary: card.dictionary)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        let index = config.flashcards.firstIndex(of: card)
                                        if let index {
                                            config.removeFlashCard(at: index)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 50)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save"){
                        if config.flashcards.count == 0 {
                            alert = AlertInfo(id: .emptyDeck, title: "Unable to Save Changes", message: "Decks must have at least one flashcard.")
                        } else if config.name == "" {
                            alert = AlertInfo(id: .emptyTitle, title: "Unable to Save Changes", message: "Title is required.")
                        } else if config.emoji == "" || config.emoji == " " {
                            alert = AlertInfo(id: .emptyEmoji, title: "Unable to Save Changes", message: "Emoji is required.")
                        } else {
                            saveConfig(topic: &topic, config: &config, isNewTopic: isNewTopic)
                            isPresented = false
                            dismiss()
                        }
                    }
                    .foregroundColor(.blue)
                    .alert(item: $alert) { info in
                        Alert(title: Text(info.title), message: Text(info.message))
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

struct AddCardRow: View {
    @Binding var config: Config
    @State var searchTerm = ""
    @State var failedSearchTerm: String? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("New Card: ")
                    .fontWeight(.semibold)
                TextField("", text: $searchTerm)
                    .onSubmit {
                        failedSearchTerm = nil
                        searchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                        let currentWord = searchTerm
                        Task {
                            do {
                                let d = try await fetchDictionary(word: currentWord)
                                config.flashcards.append(Topic.TopicItem(dictionary: d, order: config.nextCardIndex))
                                searchTerm = ""
                            } catch {
                                failedSearchTerm = currentWord
                            }
                        }
                    }
            }
            if let failedSearchTerm = failedSearchTerm {
                Text("No results for \"\(failedSearchTerm)\".")
                    .font(.callout)
                    .foregroundColor(Color("Text2"))
            }
        }
    }
}

struct DisclosureGroupContent: View {
    let definitionArray: [Definition]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(definitionArray.indices, id: \.self) { index in
                Text("\(index+1). \(definitionArray[index].definition)")
                if let example = definitionArray[index].example {
                    Text("\"\(example)\"")
                        .italic()
                        .foregroundColor(Color("Text2"))
                }
                Text("")
            }
        }
        .textSelection(.enabled)
    }
}

struct EditDeckListRow: View {
    let dictionary: Dictionary
    @State var isExpanded: Bool = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            let definitionArray = dictionary.definitions
            DisclosureGroupContent(definitionArray: definitionArray, isExpanded: $isExpanded)
        } label: {
            Button(dictionary.word.capitalized) {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            .foregroundColor(Color("Text1"))
        }
    }
}

//#Preview {
//    @StateObject var store = Store()
//    
//    EditDeckView()
//    .environmentObject(store.manager)
//    .task {
//        do {
//            try await store.load()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//}
