//
//  AllTopicsListView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

//struct AllTopicsListView: View {
//    @State private var isPresented = false
//
//    var body: some View {
//       VStack{
//            HStack{
//                Text("My Current Learning")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding()
//                Spacer()
//                Button{
//                    isPresented.toggle()
//                } label: {
//                    Image(systemName: "plus.circle")
//                    .frame(width: 20, height: 20, alignment: .trailing)
//                    .padding()
//                }
//            }.sheet(isPresented: $isPresented){
//                LearningOptionsView(topics: topicsList, dismissAction: {
//                    isPresented.toggle()
//                })
//            }
//
//            Spacer()
//        }
//    }
//}

struct AllTopicsListView: View{
    @EnvironmentObject var tm: TopicManager
    var columns = [GridItem(.adaptive(minimum: 150))]
    var topics: [Topic]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns){
                    ForEach(topics){ topic in
                        TopicCard(topic: topic)
                            .onTapGesture {
                                tm.add(topic: topic)
//                                topic.createFlashCards()
                            }
                    }
                }.padding()
            }
            .background(Color(hue: 0.583, saturation: 0.266, brightness: 0.944, opacity: 0.775))
            .navigationTitle("Learn Something New!")
        }
        
    }
}

struct AllTopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        var t: Topic = Topic(name: "North American Cat Breeds", image: Image("cat"))
        var myTopicsList = [t]
        
        AllTopicsListView(topics: myTopicsList)
    }
}
