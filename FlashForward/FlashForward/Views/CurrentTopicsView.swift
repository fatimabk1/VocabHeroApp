//
//  CurrentTopicsView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

// takes a topic to edit
// passed topic is a copy of existing or a new topic
struct Config {
    var name = ""
    var emoji = ""
    var flashcards: [Topic.TopicItem] = []
    var additions: [Dictionary] = []
    var nextCardIndex: Int {
        let orderIndexArray = flashcards.map { $0.orderIndex }
        let orderIndex = orderIndexArray.max() ?? 0
        return (orderIndex > 0) ? (orderIndex + 1) : orderIndex
    }
    
    init(topic: Topic? = nil) {
        let baseTopic = topic ?? Topic()
        name = baseTopic.name
        emoji = baseTopic.emoji
        flashcards = baseTopic.flashCards
    }
    
    func toStr() -> String {
        var text = "\(emoji) \(name):"
        for card in flashcards {
            text += "\n \(card.toStr())"
        }
        return text
    }
}

struct SimpleEditDeckView: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.dismiss) var dismiss
    
    // received from above
    @Binding var topic: Topic
    @Binding var isPresented: Bool
    let isNewTopic: Bool
    let source: String
    
    // local to view
    @State var config: Config
    @State var additions: [Dictionary] = []
    @State var newTopic = Topic()
    @State var emptyDeckAlert = false
    
    init(topic: Binding<Topic>, isPresented: Binding<Bool>, isNewTopic: Bool, source: String) {
        _topic = topic
        _config = State(initialValue: Config(topic: topic.wrappedValue))
        _isPresented = isPresented
        self.isNewTopic = isNewTopic
        self.source = source
    }
    
    func saveConfig(topic: inout Topic, config: inout Config, isNewTopic: Bool){
        // TODO: make sure that everything in topic that should be updated gets updated
        topic.name = config.name
        topic.emoji = config.emoji
        for d in additions {
            topic.addFlashCard(dictionary: d)
        }
        topic.flashCards = config.flashcards
        
        if isNewTopic {
            manager.addSet(topic)
        }
    }
    
    var body: some View {
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
                    }
                }
                List {
                    Section("Flashcards") {
                        AddCardRow(config: $config)
                        ForEach($config.flashcards) { $card in
                            EditDeckListRow(card: card)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        let index = config.flashcards.firstIndex(of: card)
                                        if let index {
                                            config.flashcards.remove(at: index)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
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
                            emptyDeckAlert = true
                        } else {
                            saveConfig(topic: &topic, config: &config, isNewTopic: isNewTopic)
                            isPresented = false
                            dismiss()
                        }
                    }
                    .alert(isPresented: $emptyDeckAlert) {
                        Alert(title: Text("Unable to Save Changes"), message: Text("Decks must have at least one flashcard."))
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
        VStack { // TODO: emphasize the new card row + make space for err msg
            HStack {
                Text("New Card: ")
                    .fontWeight(.semibold)
                TextField("", text: $searchTerm)
                    .onSubmit {
                        failedSearchTerm = nil
                        // TODO: remove preceding/trailing spaces around search term
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
            }
        }
    }
}

struct DisclosureGroupContent: View {
    let definitionArray: [Definition]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack {
            ForEach(definitionArray.indices, id: \.self) { index in
                Text("\(index+1). \(definitionArray[index].definition)")
                if let example = definitionArray[index].example {
                    Text("\"\(example)\"")
                        .italic()
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct EditDeckListRow: View {
    let card: Topic.TopicItem
    @State var isExpanded: Bool = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            let definitionArray = card.dictionary.definitions
            DisclosureGroupContent(definitionArray: definitionArray, isExpanded: $isExpanded)
        } label: {
            Button(card.dictionary.word) {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            .foregroundColor(.black)
        }
    }
}

struct CurrentTopicsView: View {
    @EnvironmentObject var manager: TopicManager
    @State var isEditing = false
    @State var newEditIsPresented = false
    @State var existingEditIsPresented = false
    @State var newTopic = Topic()
    @State var editTopic: Binding<Topic>? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($manager.topics) { $topic in
                    NavigationLink(destination: FlashCardView(topic: $topic)) {
                        topicListRow(topic: $topic, isEditing: true)
                            .contextMenu {
                                Button(role: .none) {
                                    editTopic = $topic
                                    existingEditIsPresented.toggle()
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    manager.removeSet(topic)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .sheet(item: $editTopic) { $topic in
                SimpleEditDeckView(topic: $topic, isPresented: $existingEditIsPresented, isNewTopic: false, source: "from edit existing")
            }
            .environment(\.defaultMinListRowHeight, 70)
            .listStyle(.inset)
            .toolbar {
                // button to add new deck
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newEditIsPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.body)
                        }.padding()
                    }
                    .sheet(isPresented: $newEditIsPresented) {
                        SimpleEditDeckView(topic: $newTopic, isPresented: $newEditIsPresented, isNewTopic: true, source: "from edit NEW")
                            .onDisappear() {
                                newTopic = Topic()
                            }
                    }
                }
            }
            .navigationTitle("Current Topics")
        }
    }
}

// TODO: get a nicer looking empty state
struct emptyStatePrompt: View {
    var body: some View {
        Text("Hit the plus button to add a new deck!")
            .font(.title)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct topicListRow: View {
    @Binding var topic: Topic
    let isEditing: Bool
    
    // TODO: display 0/total before viewed deck once, then 1/total
    var body: some View {
        let progress = topic.viewedDeck ? ((topic.shuffled ? topic.lastShuffledCard : topic.lastOrderedCard) + 1) : 0
        VStack {
            HStack {
                Text("\(topic.emoji) ")
                    .font(.title)
                VStack(alignment: .leading) {
                    Text(topic.name)
                        .foregroundColor(.black)
                    Text("Completed \(progress)/\(topic.total)")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                Spacer()
                circularProgress(progress: Double(progress) / Double(topic.total))
                    .frame(height: 30)
            }
            if topic.total == 0 {
                Text("Add cards to enable this deck")
                    .font(.footnote)
            }
        }
        .onAppear() {
            print("\(topic.viewedDeck ? "viewed" : "not viewed")")
            print("\(topic.shuffled ? "shuffled = \(topic.lastShuffledCard)" : "ordered = \(topic.lastOrderedCard)")")
            print("progress = \(progress)")
        }
    }
}

// sourced from https://sarunw.com/posts/swiftui-circular-progress-bar/
struct circularProgress: View {
    let progress: Double
    
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .stroke(
                        Color.teal.opacity(0.3),
                        lineWidth: 8
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.teal,
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}


struct CurrentTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var manager : TopicManager = TopicManager()
        CurrentTopicsView()
            .environmentObject(manager)
    }
}
