//
//  CurrentTopicsView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI



struct CurrentTopicsView: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.colorScheme) var colorScheme
    
    @State var isEditing = false
    @State var newEditIsPresented = false
    @State var existingEditIsPresented = false
    @State var deleteDeckAlert = false
    @State var newTopic = Topic()
    @State var editTopic: Binding<Topic>? = nil
    @State var deleteTopic: Topic? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                if manager.topics.count == 0 {
                    ZStack {
                        Image(colorScheme == .dark ? "NoDecksDark" : "NoDecksLight")
                            .resizable()
                            .frame(width: 500)
                            .offset(x: 70, y: 50)
                        Text("No decks here.")
                            .font(.title)
                            .padding()
                            .fixedSize(horizontal: false, vertical: true)
                            .offset(x: -50, y: -120)
                    }
                } else {
                    List {
                        ForEach($manager.topics) { $topic in
                            NavigationLink(destination: FlashCardView(topic: $topic)) {
                                topicListRow(topic: $topic, isEditing: true)
                                    .swipeActions(content: {
                                        Button(role: .destructive) {
                                            deleteTopic = topic
                                            deleteDeckAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(Color("Trash"))
                                        Button(role: .none) {
                                            editTopic = $topic
                                            existingEditIsPresented.toggle()
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(Color("Edit"))
                                        
                                    })
                            }
                            .listRowSeparatorTint(Color(.gray))
                        }
                    }
                    .alert("This action cannot be undone.", isPresented: $deleteDeckAlert, presenting: deleteTopic, actions: { deleteTopic in
                        Button("delete", role: .destructive) {
                            manager.removeSet(deleteTopic)
                        }
                        Button("cancel", role: .cancel) { deleteDeckAlert = false }
                    })
                    .sheet(item: $editTopic) { $topic in
                        EditDeckView(topic: $topic, isPresented: $existingEditIsPresented, isNewTopic: false)
                    }
                    .environment(\.defaultMinListRowHeight, 70)
                    .listStyle(.inset)
                }
            }
            .toolbar {
                // button to add new deck
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newEditIsPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .font(.body)
                                .foregroundColor(Color("AccentColor"))
                                .frame(width: 30, height: 30)
                        }.padding()
                    }
                    .sheet(isPresented: $newEditIsPresented) {
                        EditDeckView(topic: $newTopic, isPresented: $newEditIsPresented, isNewTopic: true)
                            .onDisappear() {
                                newTopic = Topic()
                            }
                    }
                }
            }
            .navigationTitle("Flashcard Decks")
        }
    }
}

struct topicListRow: View {
    @Binding var topic: Topic
    let isEditing: Bool
    
    var body: some View {
        let progress = topic.viewedDeck ? ((topic.shuffled ? topic.lastShuffledCard : topic.lastOrderedCard) + 1) : 0
        VStack {
            HStack {
                Text("\(topic.emoji) ")
                    .font(.title)
                    .foregroundColor(Color("Theme"))
                VStack(alignment: .leading) {
                    Text(topic.name)
                    Text("Completed \(progress)/\(topic.total)")
                        .font(.callout)
                        .foregroundColor(Color("Text2"))
                }
                Spacer()
                circularProgress(progress: Double(progress) / Double(topic.total))
                    .frame(height: 30)
            }
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
                        Color("AccentColor").opacity(0.3),
                        lineWidth: 8
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color("AccentColor"),
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
        @StateObject var store = Store()
        
        CurrentTopicsView()
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
