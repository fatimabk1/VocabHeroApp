//
//  CurrentTopicsView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct CurrentTopicsView: View {
    @EnvironmentObject var manager: TopicManager
    
    var body: some View {
        VStack{
            NavigationStack {
                NavigationStack {
                    if manager.topics.isEmpty{
                        Text("Visit the Discover tab to add a new flash card set!")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        List(manager.topics) { topic in
                            NavigationLink {
                                FlashCardView(topic: topic)
                            } label: {
                                HStack {
                                    Text(topic.name)
                                    Spacer()
                                    Text("Completed \(topic.progress)/\(topic.total)")
                                    
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Current Learning")
                .toolbar {
                    Button(action: {
                        manager.clear()
                    }, label: {
                        HStack{
                            Spacer()
                            Text("Delete All")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.trailing)
                        }.padding()
                    })
                }
            }
            
        }
        
}
        
//        VStack{
//            HStack{
//                Text("My Current Learning")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding()
//                Spacer()
//                Button{
//                    Image("cat")
//                } label: {
//                    Image(systemName: "plus.circle")
//                    .frame(width: 20, height: 20, alignment: .trailing)
//                    .padding()
//                }
//            }
//
//            Spacer()
//        }
//    }
}

struct CurrentTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        let manager : TopicManager = TopicManager()
        CurrentTopicsView()
            .environmentObject(manager)
    }
}
