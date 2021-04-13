//
//  AstronautView.swift
//  Moonshot
//
//  Created by Hiren Patel on 4/13/21.
//

import SwiftUI

struct AstronautView: View {
    
    struct AstronautMission: Identifiable {
        var id: Int {
            mission.id
        }
        let mission: Mission
        let missionRole: String
    }
    
    let astronaut: Astronaut
    let missions: [AstronautMission]

    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        let allMissions: [Mission] = Bundle.main.decode("missions.json")
        
        var matches = [AstronautMission]()
        
        for member in allMissions {
            if let match = member.crew.first(where: { $0.name == astronaut.id }) {
                matches.append(AstronautMission(mission: member,
                    missionRole: match.role))
            }
        }
        
        self.missions = matches
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    ForEach(self.missions) { astronautMission in
                        HStack {
                            Image(astronautMission.mission.image)
                                .resizable()
                                .frame(width: 83, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.primary, lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text("\(astronautMission.mission.displayName) (\(astronautMission.missionRole))")
                                    .font(.headline)
                                Text(astronautMission.mission.formattedLaunchDate)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[7])
    }
}
