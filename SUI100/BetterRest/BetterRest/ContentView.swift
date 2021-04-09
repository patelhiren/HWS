//
//  ContentView.swift
//  BetterRest
//
//  Created by Hiren Patel on 4/7/21.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var recommendedBedTime: String? {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let modelConfiguration: MLModelConfiguration = {
                    let config = MLModelConfiguration()
                    config.computeUnits = .all
                    return config
                }()
            
            let model = try SleepCalculator(configuration: modelConfiguration)
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            return formatter.string(from: sleepTime)
        } catch {
            
        }
        
        return nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")) {
                    
                    // We can use Stepper or Picker. Both examples here.
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                    
                    // Create a binding for picker since picker is 0 based.
                    let coffeeAmountBinding = Binding<Int>(
                        get: {
                            self.coffeeAmount - 1
                        },
                        set: {
                            self.coffeeAmount = $0 + 1
                        })
                    
                    Picker("", selection: coffeeAmountBinding) {
                        ForEach(1..<21) {
                            if $0 == 1 {
                                Text("\($0) cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    }
                }
                
                Section(header: Text("Your ideal bedtime")){
                    if let bedTime = recommendedBedTime {
                        Text(bedTime)
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    else {
                        Text("Sorry, there was a problem calculating your bedtime.")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
