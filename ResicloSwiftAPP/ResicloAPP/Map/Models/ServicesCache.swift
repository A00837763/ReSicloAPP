import Foundation
import SwiftData

class CacheService {
     let modelContext: ModelContext
     let cacheDuration: TimeInterval = 24 * 60 * 60 // 24 hours
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadFromCache() throws -> [RecyclingCenter]? {
        let descriptor = FetchDescriptor<StoredRecyclingCenter>()
        let storedCenters = try modelContext.fetch(descriptor)
        
        if storedCenters.isEmpty || shouldRefreshCache() {
            return nil
        }
        
        return storedCenters.map { $0.toRecyclingCenter }
    }
    
    func saveToCache(_ centers: [RecyclingCenter]) throws {
        try clearExistingCache()
        centers.forEach { center in
            modelContext.insert(StoredRecyclingCenter(from: center))
        }
        try modelContext.save()
    }
    
     func clearExistingCache() throws {
        let descriptor = FetchDescriptor<StoredRecyclingCenter>()
        let existingCenters = try modelContext.fetch(descriptor)
        existingCenters.forEach { modelContext.delete($0) }
    }
    
     func shouldRefreshCache() -> Bool {
        do {
            let descriptor = FetchDescriptor<StoredRecyclingCenter>(sortBy: [SortDescriptor(\.lastUpdated)])
            let storedCenters = try modelContext.fetch(descriptor)
            guard let lastUpdated = storedCenters.first?.lastUpdated else { return true }
            return Date().timeIntervalSince(lastUpdated) > cacheDuration
        } catch {
            print("Error checking cache: \(error)")
            return true
        }
    }
}
