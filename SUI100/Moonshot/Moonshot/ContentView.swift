//
//  ContentView.swift
//  Moonshot
//
//  Created by Hiren Patel on 4/13/21.
//

import SwiftUI


struct ContentView: View {
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showingCrewNames = true
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    if !showingCrewNames {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        VStack(alignment: .leading,
                               spacing: 10
                        ) {
                            Text(mission.displayName)
                                .font(.headline)
                            Text(mission.formattedLaunchDate)
                        }
                    }
                    else {
                        VStack(alignment: .leading,
                               spacing: 20) {
                            HStack(spacing: 10) {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                Text(mission.displayName)
                                    .font(.headline)
                            }
                            MissionCrewView(mission: mission,
                                            astronauts: self.astronauts)
                        }
                    }
                }
                .navigationBarItems(trailing:
                    Button(action: toggleCrewNames) {
                        if showingCrewNames {
                            Text("Show 🗓")
                        }
                        else {
                            Text("Show 🧑🏽‍🚀")
                        }
                    }
                )
            }
            .navigationBarTitle("Moonshot")
        }
    }
    
    private func toggleCrewNames() {
        withAnimation() {
            showingCrewNames.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
