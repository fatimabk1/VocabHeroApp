//
//  Data.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 9/24/23.
//

import Foundation
import SwiftUI


// URL https://api.dictionaryapi.dev/api/v2/entries/en/
// part of speech
// Origin
// MEANINGS  1 & 2, examples 1 & 2

struct Dictionary: Identifiable {
    let id = UUID()
    var word: String
    var definitions: [Definition]
}

// JSON structure matching my data
struct JSONData: Decodable {
    let word: String
    let meanings: [Meaning]
}

struct Meaning: Decodable {
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Decodable {
    let definition: String
    let example: String?
}

enum FetchError: Error {
    case invalidURL
    case requestFailed
    case parseFailed
}

func fetchAllDictionaries(words: [String]) async throws -> [Dictionary] {
    return try await withThrowingTaskGroup(of: Dictionary.self) { taskGroup in
        var dictionaries =  [Dictionary]()
        for word in words {
            taskGroup.addTask { return try await fetchDictionary(word: word) }
        }
        for try await dictionary in taskGroup {
          dictionaries.append(dictionary)
        }
        return dictionaries
    }
}


func fetchDictionary(word: String) async throws -> Dictionary {
    let baseURL = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    guard let wordURL = URL(string: baseURL + word) else { throw FetchError.invalidURL }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: wordURL)
        let dictionaryWord = try parseJSON(data: data)
        return dictionaryWord
    } catch {
        print("fetchDictionary ERROR: \(error)")
        throw FetchError.requestFailed
    }
}


func parseJSON(data: Data) throws -> Dictionary {
    do {
        let decodedData: [JSONData] = try JSONDecoder().decode([JSONData].self, from: data)
        
        if let firstDecodedData = decodedData.first {
            let word = firstDecodedData.word
            print("WORD: \(word)")
            
            var definitionArray: [Definition] = []
            for meaning in firstDecodedData.meanings {
                for definition in meaning.definitions {
                    definitionArray.append(Definition(definition: definition.definition, example: definition.example ?? nil))
                }
            }
            return Dictionary(word: word, definitions: definitionArray)
        } else {
            throw FetchError.parseFailed
        }
    } catch {
        print("parseDecodeJSON error: \(error)")
        throw FetchError.parseFailed
    }
}

// TODO: START HERE -
/*
 
 (1) EditDeckView
 - takes a Topic?. If nil, create one for editing, else display current in list
 - Topic name w emoji icon
 - Search bar
 - Display words + definitions in list as added (adds to the top and push down)
 - Save button saves current array of dictionaries as a deck
 - swipe to delete removes
 - link to this view from currentTopics plus sign

 (2) Tab View
 - one tab for quick search w/swipe to add to set feature (display recent searches in list below quick search)
 - one tab for viewing current decks + deck creation
 - how to display most recent
 
 (3) FlashCardView
 - add toggle for classic view and efficient view
 - efficient view is list, but on tap switches display of word vs definition, progress shown as colored bar along side, star to left of list item
 
 (4) Persist Data
 
 (5) Color scheme, icon, dark mode
 
 */

struct EditDeckView: View {
    @State var dictionaries: [Dictionary] = []
    @State var wordSearch: [String] = []
    @State var word = ""
    @State var showingAlert: Bool = false
    @State var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $word, prompt: Text("Search"))
                        Spacer()
                    }
                    wordSearchButton(wordSearch: $wordSearch, word: word, dictionaries: $dictionaries)
                }
                .padding(.horizontal)
                List {
                    Section("Searched words:") {
                        ForEach(wordSearch, id: \.self){ w in
                            Text(w)
                        }
                    }
                }
                List {
                    ForEach(dictionaries) { dictionary in
                        VStack(alignment: .leading){
                            Text(dictionary.word)
                                .font(.headline)
                            let definitionArray = dictionary.definitions
                            ForEach(definitionArray.indices, id: \.self) { index in
                                Text("\(index+1). \(definitionArray[index].definition)")
                                if let example = definitionArray[index].example {
                                    Text("\"\(example)\"")
                                        .italic()
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }

                        
                    }
                    
                }
            }
            .navigationTitle("Definition Search")
        }
    }
}


struct wordSearchButton: View {
    @Binding var wordSearch: [String]
    let word: String
    @Binding var dictionaries: [Dictionary]
    
    var body: some View {
        Button("Search"){
            wordSearch.append(word)
            Task {
                do {
                    dictionaries = try await fetchAllDictionaries(words: wordSearch)
                } catch {
                    print("dictionaryView error: \(error)")
                }
            }
        }
    }
}
