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

struct Dictionary: Identifiable, Equatable, Hashable {

    let id = UUID()
    var word: String
    var definitions: [Definition]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Dictionary, rhs: Dictionary) -> Bool {
        return (lhs.id == rhs.id &&
                lhs.word == rhs.word &&
                lhs.definitions == rhs.definitions)
    }
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

struct Definition: Decodable, Equatable {
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
 - Navigation to edit view from existing vs new topic
 - Edit and save from existing topic
 - Edit and save from new topic
 - Display words + definitions in order added (adds to the top and push down)

 (2) Tab View
 - one tab for quick search w/swipe to add to set feature (display recent searches in list below quick search)
 - one tab for viewing current decks + deck creation
 - how to display most recent
 
 (3) FlashCardView // SKIP
 - add toggle for classic view and efficient view
 - efficient view is list, but on tap switches display of word vs definition, progress shown as colored bar along side, star to left of list item
 
 (4) Persist Data
 
 (5) Color scheme, icon, dark mode
 
 */
