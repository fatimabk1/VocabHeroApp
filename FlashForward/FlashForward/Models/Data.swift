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
    var example: String
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
    let example: String
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
    
func parseDecodeJSON(data: Data) -> [Dictionary]? {
    
    do {
        // parse JSON into array of JSONData objects
        let decodedData: [JSONData] = try JSONDecoder().decode([JSONData].self, from: data)
        
        let dictionaries = decodedData.map { JSONData in // for each item in decodedData (expecting only 1)
            let firstMeaning = JSONData.meanings.first
            let firstDefinition = firstMeaning?.definitions.first
            return Dictionary(
                word: JSONData.word,
                partOfSpeech: firstMeaning?.partOfSpeech ?? "",
                definition: firstDefinition?.definition ?? "",
                example: firstDefinition?.example ?? ""
            )
        }
        return dictionaries
    } catch {
        print("parseDecodeJSON error: \(error)")
        return nil
    }
    
}

struct dictionaryView: View {
    @State var dictionaryItems: [Dictionary]?
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
                                self.dictionaryItems = parseDecodeJSON(data: data)
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
//                    if let items = dictionaryItems {
                    ForEach(dictionaryItems?.indices ?? (0..<0), id: \.self) { index in
                            if let dict = dictionaryItems?[index]{
                                Section {
                                    VStack(alignment: .leading){
                                        Text("\(index+1). \(Text(dict.partOfSpeech).italic())")
                                        Text("\(dict.definition)")
                                        Text("\"\(dict.example)\"")
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
