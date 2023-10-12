//
//  SearchView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 10/6/23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var manager: TopicManager
    @State var searchTerm = ""
    @State var failedSearchTerm: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ZStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search...", text: $searchTerm)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .onSubmit {
                        failedSearchTerm = nil
                        searchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                        let currentWord = searchTerm
                        Task {
                            do {
                                if currentWord != "" {
                                    manager.searchedDictionary = try await fetchDictionary(word: currentWord)
                                }
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
                    Spacer()
                } else {
                    let searchedDictionary = manager.searchedDictionary
                    VStack(alignment: .leading) {
                        Text(searchedDictionary.word.capitalized(with: .current))
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding()
                        Divider()
                        ScrollView {
                            VStack(alignment: .leading) {
                                let definitions = searchedDictionary.definitions
                                ForEach(definitions.indices, id: \.self) { index in
                                    Text("\(index + 1). \(definitions[index].definition)")
                                        .foregroundStyle(Color("Text1"))
                                        .font(.body)
                                    if let example = definitions[index].example {
                                        Text("\"\(example)\"")
                                            .foregroundStyle(Color("Text2"))
                                            .font(.callout)
                                            .italic()
                                    }
                                    Divider()
                                }
                            }
                            .padding()
                        }
                    }
                    .textSelection(.enabled)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Dictionary")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
