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
}

struct SimpleEditDeckView: View {
    @EnvironmentObject var manager: TopicManager
    @Binding var topic: Topic?
    @State var newTopic = Topic()
    var isNewTopic: Bool { topic != nil ? false : true }
    @State var config: Config
    @State var additions: [Dictionary] = []
    
    init(topic: Binding<Topic?>) {
        _topic = topic
        _config = State(initialValue: topic.wrappedValue != nil ? Config(topic: topic.wrappedValue!) : Config())
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
        VStack {
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
        }
        Button("Save"){
            if isNewTopic {
                saveConfig(topic: &newTopic, config: &config, isNewTopic: isNewTopic)
            } else {
                saveConfig(topic: &topic!, config: &config, isNewTopic: isNewTopic)
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
    
    var body: some View {
        NavigationStack {
            List($manager.topics) { $topic in
                NavigationLink {
                    if isEditing {
                        SimpleEditDeckView(topic: Binding($topic))
                            .onDisappear(){
                                isEditing.toggle()
                            }
                        
                    } else {
                        FlashCardView(topic: $topic)
                    }
                } label: {
                    topicListRow(topic: $topic)
                }
            }
            .environment(\.defaultMinListRowHeight, 70)
            .listStyle(.inset)
            Button(isEditing ? "Cancel" : "Edit"){
                isEditing.toggle()
            }
            .navigationTitle(isEditing ? "Editing Current Topics" : "Current Topics")
            .toolbar {
                // button to add new deck
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SimpleEditDeckView(topic: .constant(nil))
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.body)
                        }.padding()
                    }
                }
            }
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
    var body: some View {
        HStack {
            Text("\(topic.emoji) ")
                .font(.title)
            VStack(alignment: .leading){
                Text(topic.name)
                    .foregroundColor(.black)
                Text("Completed \(topic.progress)/\(topic.total)")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            Spacer()
            circularProgress(progress: topic.progressIndicatorValue)
                .frame(height: 30)
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
