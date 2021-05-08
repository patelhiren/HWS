//
//  ContentView.swift
//  HabitTracker
//
//  Created by Hiren Patel on 5/8/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activities = Activities()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activities.items) { item in
                    NavigationLink(destination: ActivityDetailView(activityItem: item,
                                                                   activities: self.activities)) {
                        HStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.description)
                                    .italic()
                            }
                            
                            Spacer()
                            Text("\(item.completionCount)")
                                .fontWeight(.semibold)
                        }
                        .padding(0)
                        .edgesIgnoringSafeArea(.all)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("Habit Tracker")
            .navigationBarItems(leading: EditButton(),
                                trailing:
                                    Button(action: {
                                        self.showingAddActivity = true
                                    }) {
                                        Image(systemName: "plus")
                                    }
            )
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView(activities: self.activities)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        activities.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
