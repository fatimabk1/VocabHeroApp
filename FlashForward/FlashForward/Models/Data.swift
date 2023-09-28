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

// My custom dictionary struct
struct Dictionary: Identifiable {
    let id = UUID()
    var word: String
    var partOfSpeech: String
    var definition: String
    var example: String?
}

struct MyTopicItem: Identifiable {
    let id = UUID()
    var word: String
    var definitions: [String]
    var examples: [String]
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

func fetchAllDictionaries(words: [String]) async throws -> [MyTopicItem] {
    return try await withThrowingTaskGroup(of: MyTopicItem.self) { taskGroup in
        var dictionaries =  [MyTopicItem]()
        for word in words {
            taskGroup.addTask { return try await fetchDictionary(word: word) }
        }
        for try await dictionary in taskGroup {
          dictionaries.append(dictionary)
        }
        return dictionaries
    }
}


func fetchDictionary(word: String) async throws -> MyTopicItem {
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


func parseJSON(data: Data) throws -> MyTopicItem {
    do {
        let decodedData: [JSONData] = try JSONDecoder().decode([JSONData].self, from: data)
        
        if let firstDecodedData = decodedData.first {
            let word = firstDecodedData.word
            print("WORD: \(word)")
            
            var definitionArray: [String] = []
            var exampleArray: [String] = []
            for meaning in firstDecodedData.meanings {
                for definition in meaning.definitions {
                    print("DEF: \(definition.definition)")
                    definitionArray.append(definition.definition)
                    if let example = definition.example {
                        exampleArray.append(example)
                    }
                }
            }
            return MyTopicItem(word: word, definitions: definitionArray, examples: exampleArray)
        } else {
            throw FetchError.parseFailed
        }
    } catch {
        print("parseDecodeJSON error: \(error)")
        throw FetchError.parseFailed
    }
}


struct dictionaryView: View {
    @State var dictionaries: [MyTopicItem] = []
    @State var wordSearch: [String] = []
    @State var word = ""
    @State var showingAlert: Bool = false
    @State var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    TextField("WordSearch", text: $word, prompt: Text("Enter a word"))
                    wordSearchButton(wordSearch: $wordSearch, word: word, dictionaries: $dictionaries)
                }
                .padding(50)
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
                            if !dictionary.definitions.isEmpty {
                                Text(dictionary.definitions[0])
                            }
                            if !dictionary.examples.isEmpty {
                                Text("\"\(dictionary.examples[0])\"").italic()
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
    @Binding var dictionaries: [MyTopicItem]
    
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
