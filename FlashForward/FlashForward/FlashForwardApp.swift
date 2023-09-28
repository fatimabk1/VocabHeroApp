//
//  FlashForwardApp.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/18/23.
//

import SwiftUI


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
//
//    var body: some Scene {
//        WindowGroup {
//            dictionaryView()
//        }
//    }
//}
