//
//  FlashForwardApp.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/18/23.
//

import SwiftUI
// TODO: uncomment - removed for testing purposes
@main
struct FlashForwardApp: App {
    @StateObject var manager = TopicManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}

//@main
//struct FlashForwardApp: App {
//    @StateObject var library = Library()
//
//    var body: some Scene {
//        WindowGroup {
//            View1()
//                .environmentObject(library)
//        }
//    }
//}
