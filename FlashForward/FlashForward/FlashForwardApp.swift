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

    var body: some Scene {
        WindowGroup {
            ContentView() {
                Task {
                    do {
                        try await store.save(manager: store.manager)
                        } catch {
                            print(error)
                            fatalError(error.localizedDescription)
                        }
                }
            }
            .environmentObject(store.manager)
            .task {
                    do {
                        try await store.load()
                        store.manager.isLoading = false
                    } catch {
                        print(error)
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
