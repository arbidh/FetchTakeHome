//
//  DataService.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//
import SwiftData
import Foundation

protocol DataServiceable {
    associatedtype T: PersistentModel
    func fetchAll() async throws -> [T]
    func fetch(from id: String) async throws -> T?
    func add(_ item: T) async throws
    func remove(from id: String) async throws
    func isMatching( from id: String) async -> Bool 
}

protocol IdentifiableModel: PersistentModel {
    var id: String { get }
}

@Observable
@MainActor
class DataService<T: IdentifiableModel>: DataServiceable {
    private let container: ModelContainer
    
    init(schema: Schema) {
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        self.container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }
    
    func isMatching( from id: String) -> Bool {
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id }
        )
        return (try? container.mainContext.fetch(descriptor).first) != nil
    }
    
    func fetchAll() throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try container.mainContext.fetch(descriptor)
    }
    
    func fetch(from id: String) throws -> T? {
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id }
        )
        return try container.mainContext.fetch(descriptor).first
    }
    
    func add(_ item: T) throws {
        container.mainContext.insert(item)
        try container.mainContext.save()
    }
    
    func remove(from id: String) throws {
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate<T> { $0.id == id }
        )
        if let itemToDelete = try container.mainContext.fetch(descriptor).first {
            container.mainContext.delete(itemToDelete)
            try container.mainContext.save()
        }
    }
}
