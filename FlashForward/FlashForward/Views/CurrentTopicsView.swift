//
//  CurrentTopicsView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct CurrentTopicsView: View {
    @EnvironmentObject var manager: TopicManager
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            NavigationStack {
                Group {
                    if manager.topics.filter({$0.added}).isEmpty {
                        emptyStatePrompt()
                    } else {
                        displayCurrentTopics()
                    }
                }
                .navigationTitle("Current Learning")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        presentAllTopicsButton(isPresented: $isPresented)
                    }
                }
            }
        }
    }
}

// TODO: get a nicer looking empty state
struct emptyStatePrompt: View {
    var body: some View {
        Text("Visit the Discover tab to add a new flash card set!")
            .font(.title)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct topicListRow: View {
    @Binding var topic: Topic
    var body: some View {
        HStack {
            if let emoji = topic.emoji {
                Text("\(emoji) ")
                    .font(.title)
            }
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

// Start sourced from https://sarunw.com/posts/swiftui-circular-progress-bar/
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
// End sourced from https://sarunw.com/posts/swiftui-circular-progress-bar/

struct displayCurrentTopics: View {
    @EnvironmentObject var manager: TopicManager
    
    var body: some View {
        NavigationStack{
            List($manager.topics) { $topic in
                if topic.added {
                    NavigationLink {
                        FlashCardView(topic: $topic)
                    } label: {
                        topicListRow(topic: $topic)
                            .frame(height: 70)
                            .swipeActions {
                                Button(role: .destructive) {
                                    topic.removeFromLearning()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 70)
            .listStyle(.inset)
        }
    }
}

struct presentAllTopicsButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            HStack{
                Image(systemName: "plus.circle")
                    .font(.body)
            }.padding()
        })
        .sheet(isPresented: $isPresented) {
            AllTopicsListView(isPresented: $isPresented)
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
