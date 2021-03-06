//
//  ContentView.swift
//  iExpense
//
//  Created by Hiren Patel on 4/12/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }

        self.items = []
    }
    
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ContentView: View {

    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()
                        Text("$\(item.amount)")
                    }
                    .listRowBackground(getBackgroundForItem(item: item))
                    .padding(0)
                    .edgesIgnoringSafeArea(.all)
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(),
                                    trailing:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
    }
    
    func getBackgroundForItem(item: ExpenseItem) -> some View {
        if item.amount < 10 {
            return LinearGradient(gradient: Gradient(colors: [.init(.sRGB, red: 0, green: 1, blue: 0, opacity: 0.35), .green]), startPoint: .leading, endPoint: .trailing)
        }
        else if item.amount < 100 {
            return LinearGradient(gradient: Gradient(colors: [.init(.sRGB, red: 1, green: 0.65, blue: 0, opacity: 0.35), .orange]), startPoint: .leading, endPoint: .trailing)
        }
        
        return LinearGradient(gradient: Gradient(colors: [.init(.sRGB, red: 1, green: 0, blue: 0, opacity: 0.35), .red]), startPoint: .leading, endPoint: .trailing)
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
