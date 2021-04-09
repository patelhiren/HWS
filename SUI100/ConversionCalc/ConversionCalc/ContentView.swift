//
//  ContentView.swift
//  ConversionCalc
//
//  Created by Hiren Patel on 4/5/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputTemperatureValue: String = "32"
    private var temperatureUnits = ["Celcius", "Farenheit", "Kelvin"]
    @State private var inputUnit: Int = 1
    @State private var outputUnit: Int = 0
    
    var outputTemperature: Double {
        let inputTemperatureUnit:UnitTemperature
        
        if (inputUnit == 0) {
            inputTemperatureUnit = UnitTemperature.celsius
        } else if (inputUnit == 2) {
            inputTemperatureUnit = UnitTemperature.kelvin
        } else {
            inputTemperatureUnit = UnitTemperature.fahrenheit
        }
        
        let outputTemperatureUnit:UnitTemperature
        
        if (outputUnit == 1) {
            outputTemperatureUnit = UnitTemperature.fahrenheit
        } else if (outputUnit == 2) {
            outputTemperatureUnit = UnitTemperature.kelvin
        } else {
            outputTemperatureUnit = UnitTemperature.celsius
        }
        
        let inputValue = Measurement(value: Double(inputTemperatureValue) ?? 0, unit: inputTemperatureUnit)
        
        let outputValue = inputValue.converted(to: outputTemperatureUnit)
        
        return outputValue.value
    }
    
    var outputUnitText: String {
        switch outputUnit {
        case 1:
            return "F"
        case 2:
            return "K"
        default:
            return "C"
        }
    }
    
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Temperature", text: $inputTemperatureValue)
                    Picker ("Convert From",
                            selection: $inputUnit) {
                        ForEach(0 ..< temperatureUnits.count) {
                            Text("\(self.temperatureUnits[$0])")
                        }
                    }
                    Picker ("Convert To",
                            selection: $outputUnit) {
                        ForEach(0 ..< temperatureUnits.count) {
                            Text("\(self.temperatureUnits[$0])")
                        }
                    }
                }
                
                Section(header: Text("Converted Temperature")) {
                    Text("\(outputTemperature, specifier: "%.2f") °\(outputUnitText)")
                }
            }
            .navigationTitle("Temperature Converter")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
