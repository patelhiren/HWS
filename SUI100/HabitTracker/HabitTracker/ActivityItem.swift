//
//  ActivityItem.swift
//  HabitTracker
//
//  Created by Hiren Patel on 5/8/21.
//

import SwiftUI

struct ActivityItem: Identifiable, Codable, Equatable {
    private (set) var id = UUID()
    let title: String
    let description: String
    private (set) var completionCount: Int
    
    fileprivate mutating func incrementActivityCount() {
        self.completionCount += 1
    }
    
    static func == (lhs: ActivityItem, rhs: ActivityItem) -> Bool {
        return lhs.id == rhs.id
    }
}

class Activities: ObservableObject {
    let dataFilePath: URL
    
    init() {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        self.dataFilePath = documentsDirectory.appendingPathComponent("activityItems.json")
        
        
        if let activityData = try? Data.init(contentsOf: self.dataFilePath) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ActivityItem].self, from: activityData) {
                self.items = decoded
                return
            }
        }

        self.items = []
    }
    
    @Published var items = [ActivityItem]() {
        didSet {
            self.saveActivities()
        }
    }
    
    func incrementCompletionCountForActivityAtIndex(index:Array<ActivityItem>.Index) -> Int {
        items[index].incrementActivityCount()
        self.saveActivities()
        return items[index].completionCount
    }
    
    private func saveActivities() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            try? encoded.write(to: self.dataFilePath)
        }
    }
}
