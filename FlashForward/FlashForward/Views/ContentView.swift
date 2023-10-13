//
//  ContentView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    
    var body: some View {
        TabView {
            Group {
                CurrentTopicsView()
                    .tabItem { Label("Flashcards", systemImage: "rectangle.stack.fill") }
                SearchView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
            .padding(.top)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(Color("TabAccent"))
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                saveAction()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var store = Store()
        ContentView() {
            Task {
                do {
                    try await store.save(manager: store.manager)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
            }
        }
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
