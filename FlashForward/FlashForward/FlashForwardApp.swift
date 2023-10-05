//
//  FlashForwardApp.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/18/23.
//

import SwiftUI


@main
struct FlashForwardApp: App {
    @StateObject private var store = Store()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            CurrentTopicsView() {
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
}
