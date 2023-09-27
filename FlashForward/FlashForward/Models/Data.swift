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


func loadData(word: String, completion: @escaping(Result<Data, Error>) -> Void){
     let url = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    
    // validate URL
    guard let url = URL(string: url + word) else {
        completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
        return
    }
    
    // API call
    URLSession.shared.dataTask(with: url) { (data, _, error) in  // data, response, error
        
        if error != nil {
            completion(.failure(NSError(domain: "URLError", code: -1)))
            return
        }
        
        // received data
        if let data = data {
            completion(.success(data))
            return
        } else {
            completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
            return
        }
    }.resume()
}
    
func parseDecodeJSON(data: Data) -> MyTopicItem? {

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
        }
        return nil
    } catch {
        print("parseDecodeJSON error: \(error)")
        return nil
    }
}

struct dictionaryView: View {
    @State var topicItem: MyTopicItem?
    @State var word: String = ""
    @State var showingAlert: Bool = false
    @State var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    TextField("inculcate", text: $word, prompt: Text("Enter a word"))
                    Button("Submit"){
                        loadData(word: word) { result in
                            switch result {
                            case .failure(let error):
                                self.alertMessage = "Error loading data: \(error.localizedDescription)"
                                self.showingAlert = true
                            case .success(let data):
                                self.topicItem = parseDecodeJSON(data: data)
                            }
                        }
                        
                    }
                    .alert(alertMessage, isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                List {
                    if let topic = topicItem {
                        ForEach(topic.definitions.indices, id: \.self) { index in
                            VStack(alignment: .leading){
                                Text("\(index). \(topic.definitions[index])")
                                if index < topic.examples.count {
                                    Text("\(topic.examples[index])").italic()
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
