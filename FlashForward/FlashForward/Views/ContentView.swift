//
//  ContentView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/18/23.
//

import SwiftUI
import AnimateText

struct ContentView: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    @State var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                MainView()
            }
            else {
                LoadingView<ATTwistEffect>(elements: ["Vocab Hero"])
            }
        }
        .onChange(of: manager.isLoading) { loadStatus in
            if loadStatus == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                saveAction()
            }
        }
    }
}

struct LoadingView<E: ATTextAnimateEffect>: View {
    // text animation
    @State var text: String = "VocabHero"
    @State var type: ATUnitType = .letters
    @State var userInfo: Any? = nil
    let elements: [String]
    
    // gradient animation
    @State private var animateGradient = false
    @State var gradient = [.white, Color("TabAccent"), .black]
    @State var startPoint = UnitPoint(x: 0, y: 0)
    @State var endPoint = UnitPoint(x: 0, y: 2)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(gradient: Gradient(colors: self.gradient), startPoint: self.startPoint, endPoint: self.endPoint))
                .ignoresSafeArea()
            AnimateText<CustomEffect>($text, type: type, userInfo: userInfo)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .onAppear {
            text = ""
            changeText()
            withAnimation (.easeInOut(duration: 3).repeatForever()){
                    self.startPoint = UnitPoint(x: 1, y: -1)
                    self.endPoint = UnitPoint(x: 0, y: 1)
                }
        }
    }
    
    private func changeText() {
            let newText = self.elements[Int.random(in: (0..<self.elements.count))]
            if Bool.random() == true {
                text = newText
            }else {
                text = newText.uppercased()
            }
        }
}

struct CustomEffect: ATTextAnimateEffect {
    
    var data: ATElementData
    var userInfo: Any?
    
    var color: Color = Color("TabAccent")
    
    public init(_ data: ATElementData, _ userInfo: Any?) {
        self.data = data
        self.userInfo = userInfo
        if let info = userInfo as? [String: Any] {
            color = info["color"] as! Color
        }
    }
    
    func body(content: Self.Content) -> some View {
        ZStack {
            content
                .opacity(data.value)
            content
                .foregroundColor(color)
                .opacity(data.invValue)
        }
        .animation(.spring(response: 1.2, dampingFraction: 0.6, blendDuration: 0.9).delay(Double(data.index) * 0.10), value: data.value)
        .scaleEffect(data.scale, anchor: .bottom)
        .rotationEffect(Angle(degrees: -360 * data.invValue))
        .animation(.spring(response:1.8, dampingFraction: 0.9, blendDuration: 0.9).delay(Double(data.index) * 0.10), value: data.value)
    }
}


struct MainView: View {
    @EnvironmentObject var manager: TopicManager
    @Environment(\.scenePhase) private var scenePhase
    
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
