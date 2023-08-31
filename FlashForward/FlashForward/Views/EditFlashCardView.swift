//
//  EditFlashCardView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/23/23.
//

import SwiftUI

struct EditFlashCardView: View {
    // try lazyVGrid / ***grid*** here
//    let columns = [gridItem()]
    var body: some View {
        VStack{
            Text("Edit SetName")
                .font(.largeTitle)
                .fontWeight(.bold)
            ScrollView{
//                LazyVGrid(columns: columns){
                    ForEach(topicItemList){ item in
                        FlashCardEditable(topicItem: item)
                    }
                }
            }
            

        }
        
    }
//}

struct EditFlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditFlashCardView()
    }
}
