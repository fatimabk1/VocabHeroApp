//
//  ContentView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/18/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: TopicManager
    // TODO: add tab bar to switch between word look up & deck view
    var body: some View {
        CurrentTopicsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var manager : TopicManager = TopicManager()
        ContentView()
            .environmentObject(manager)
    }
}
