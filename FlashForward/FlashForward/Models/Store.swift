//
//  Store.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 10/4/23.
//

import Foundation

@MainActor
class Store: ObservableObject {
    @Published var manager: TopicManager = TopicManager()
    
    enum StoreError: Error {
        case corruptedFile
    }
    
    private static func fileURL() throws -> URL {
         try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
         .appendingPathComponent("store.data")
    }
    
    func load() async throws {
        let task = Task<TopicManager, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                print("Store.load(): No data - returning default manager")
                return TopicManager()
            }
                        
            do {
                let manager = try JSONDecoder().decode(TopicManager.self, from: data)
                return manager
            } catch {
                print("error: ", error)
                throw StoreError.corruptedFile
            }
        }
        
        let manager = try await task.value
        self.manager = manager
    }
    
    func save(manager: TopicManager) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(manager)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
