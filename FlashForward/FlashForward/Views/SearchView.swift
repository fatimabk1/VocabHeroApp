//
//  SearchView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 10/6/23.
//

import SwiftUI

struct SearchView: View {
    @State var searchTerm = ""
    @State var failedSearchTerm: String? = nil
    @State var searchedDictionary = Dictionary(word: "", definitions: [Definition(definition: "", example: "")])
    
    var body: some View {
        ZStack {
//            Color("Theme")
//                .ignoresSafeArea()
            VStack {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color("Theme"))
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search...", text: $searchTerm)
                                .background(Color("Theme"))
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                    }
                    .frame(height: 30)
                    .padding()
                    .onSubmit {
                        failedSearchTerm = nil
                        searchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                        let currentWord = searchTerm
                        Task {
                            do {
                                searchedDictionary = try await fetchDictionary(word: currentWord)
                                searchTerm = ""
                            } catch {
                                failedSearchTerm = currentWord
                                
                            }
                        }
                    }
                }
                if let failedSearchTerm = failedSearchTerm {
                    Text("No results for \"\(failedSearchTerm)\".")
                        .font(.callout)
                        .foregroundColor(Color("Text2"))
                }
                
                EditDeckListRow(dictionary: searchedDictionary)
                    .padding()
                Spacer()
                
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
