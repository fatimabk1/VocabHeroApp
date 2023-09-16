//
//  FlashCardEditable.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/23/23.
//

import SwiftUI
//
//struct FlashCardEditable: View {
//    let topicItem: TopicItem
////    @State private var editableText: String = topicItem.text ? topicItem.text : ""
//
//    var body: some View {
////        RoundedRectangle(cornerRadius: 30)
////                .foregroundColor(.pink)
//        HStack(spacing: 10){
//            DisplayEditableImage(/* editableImage: topicItem.image */)
//            DisplayEditableText(editableText: topicItem.$text)
//        }
//    }
//}
//
//struct DisplayEditableText: View{
//    @Binding var editableText: String?
//
//    var body: some View{
//    ZStack{
//        RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(.green)
//            .frame(width: 200, height: 150)
//        TextField("FlashCard", text: Binding(
//            get: {self.editableText ?? ""},
//            set: {self.editableText = $0.isEmpty ? nil : $0 }
//        ))
//            .frame(width: 200, height: 150)
//    }
//    }
//}
//
//
//struct DisplayEditableImage: View{
////   @Binding var editableImage: Image?
//
//    var body: some View{
//        // Display current image or stock camera
//        ZStack{
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(.green)
//                .frame(width: 200, height: 150)
//
//////            (editableImage != nil ? editableImage! : Image(systemName: "camera.fill"))
////            Binding(
////                get: {self.editableImage ?? Image(systemName: "camera.fill")},
////                set: {self.editableImage = $0}
////            )
////                .resizable()
////                .scaledToFit()
////                .frame(width: 180, height: 130)
//        }
//        .onTapGesture {
//            // allow user to upload photo
//        }
//
//    }
//}
//
//
//struct FlashCardEditable_Previews: PreviewProvider {
//    static var previews: some View {
//        FlashCardEditable(topicItem: TopicItem(text: "MyTopic", image: Image(systemName: "plus.circle")))
//    }
//}
