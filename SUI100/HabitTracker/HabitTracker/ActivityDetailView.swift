//
//  ActivityDetailView.swift
//  HabitTracker
//
//  Created by Hiren Patel on 5/8/21.
//

import SwiftUI

struct ActivityDetailView: View {
    
    @ObservedObject private var activities: Activities
    private let activityItem: ActivityItem
    @State private var completionCount: Int
    
    init(activityItem: ActivityItem, activities: Activities) {
        self.activityItem = activityItem
        self.activities = activities
        _completionCount = State<Int>(initialValue: self.activityItem.completionCount)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment:.leading, spacing: 16) {
                Text(self.activityItem.title)
                    .font(.title)
                Text(self.activityItem.description)
                    .italic()
                HStack(spacing: 8) {
                    Text("Completed")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(self.completionCount) times")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                HStack {
                    Spacer()
                    Button(action: self.incrementActivityCount) {
                        Image(systemName: "plus")
                            .frame(minWidth: 50)
                            .padding()
                            .background(Color.green)
                    }
                    .accentColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
                    
                }
                Spacer(minLength: 25)
            }
            .padding()
            .frame(width: geometry.size.width)
        }
        .navigationBarTitle(Text(self.activityItem.title), displayMode: .inline)
    }
    
    func incrementActivityCount() {
        guard let itemIndex = self.activities.items.firstIndex(where: { (item) -> Bool in
                    item == self.activityItem
        }) else {
            return
        }
        
        self.completionCount = self.activities.incrementCompletionCountForActivityAtIndex(index: itemIndex)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    
    static let activity = ActivityItem(title: "Book Reading", description: "Read a book for 30 minutes everyday.", completionCount: 0)
    
    static var previews: some View {
        ActivityDetailView(activityItem: activity, activities: Activities())
    }
}
