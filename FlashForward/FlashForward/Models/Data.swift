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

struct Dictionary: Identifiable, Equatable, Hashable, Codable {
    let id = UUID()
    var word: String
    var definitions: [Definition]
    
    static var defaultDictionary = Dictionary(word: "Search", definitions: [
        Definition(definition: "An attempt to find something.", example: "With only five minutes until we were meant to leave, the search for the keys started in earnest."),
        Definition(definition: "The act of searching in general.", example: "Search is a hard problem for computers to solve efficiently."),
        Definition(definition: "To look in (a place) for something.", example: "I searched the garden for the keys and found them in the vegetable patch."),
        Definition(definition: "(followed by \"for\") To look thoroughly.", example: nil),
        Definition(definition: "The act of defining; determination of the limits.", example: "The police are searching for evidence in his flat."),
        Definition(definition: "To look for, seek.", example: nil),
        Definition(definition: "To probe or examine (a wound).", example: nil),
        Definition(definition: "To examine; to try; to put to the test.", example: nil)
    ])
    
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

struct Definition: Identifiable, Equatable, Codable {
    let id = UUID()
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
        throw FetchError.requestFailed
    }
}


func parseJSON(data: Data) throws -> Dictionary {
    do {
        let decodedData: [JSONData] = try JSONDecoder().decode([JSONData].self, from: data)
        
        if let firstDecodedData = decodedData.first {
            let word = firstDecodedData.word
            
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
        throw FetchError.parseFailed
    }
}
