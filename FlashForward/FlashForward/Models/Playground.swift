//
//  Playground.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 9/18/23.
//

import Foundation
import SwiftUI

class Library: ObservableObject, Identifiable {
    var id = UUID()
    @Published var books: [Book] = [Book(), Book(), Book()]
}

//class Book: ObservableObject, Identifiable {
//    var id = UUID()
//    var name = "Book Title"
//    @Published var authorList = [Author(), Author(), Author()]
//}
//
//class Author: ObservableObject, Identifiable {
//    var id = UUID()
//    @Published var name = "Author Name"
//}

struct Book: Identifiable {
    var id = UUID()
    var name = "Book Title"
    var authorList = [Author(), Author(), Author()]
}

struct Author: Identifiable {
    var id = UUID()
    var name = "Author Name"
}

struct View1: View {
    @EnvironmentObject var library: Library
    
    var body: some View {
        VStack {
            NavigationStack {
                List($library.books) { $book in
                    NavigationLink {
                        View2(book: $book)
                    } label: {
                        VStack {
                            Text("\(book.name)")
                            ForEach(book.authorList) { author in
                                Text("\t\(author.name)")
                            }
                        }
                    }
                }
                .navigationTitle("Library")
            }
        }
    }
}

struct View2: View {
    @Binding var book: Book
    
    var body: some View {
        VStack {
            Text("\(book.name)")
            ForEach($book.authorList, id: \.id){ $author in
                View3(author: $author, book: $book)
            }
        }
    }
}

struct View3: View {
     @Binding var author: Author
     @Binding var book: Book
    
    var body: some View {
        HStack{
            Text("\(author.name)")
        }
        .onTapGesture {
            author.name = "Renamed~"
            book.name = "My selected book"
        }
    }
}

struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var library = Library()
        View1()
            .environmentObject(library)
    }
}
