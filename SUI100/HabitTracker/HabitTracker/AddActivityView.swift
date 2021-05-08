//
//  AddActivityView.swift
//  HabitTracker
//
//  Created by Hiren Patel on 5/8/21.
//

import SwiftUI

struct AddActivityView: View {
    
    @ObservedObject var activities: Activities
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    
    @State private var errorTitle = "Invalid Value"
    @State private var errorMessage = ""
    @State private var isShowingAlert = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationBarTitle("Add new activity")
            .navigationBarItems(trailing: Button("Save") {
                let item = ActivityItem(title: self.title, description: self.description, completionCount: 0)
                self.activities.items.append(item)
                self.presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: self.$isShowingAlert) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(activities: Activities())
    }
}
