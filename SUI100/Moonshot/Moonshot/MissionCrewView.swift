//
//  MissionCrewView.swift
//  Moonshot
//
//  Created by Hiren Patel on 4/13/21.
//

import SwiftUI

struct MissionCrewView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
    
    var body: some View {
        VStack {
            Text("🚀 Launch Crew")
                .font(.body)
                .fontWeight(.heavy)
            
            HStack(alignment: .top, spacing: 8) {
                ForEach(self.astronauts, id: \.role) { crewMember in
                        VStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.primary, lineWidth: 1))
                            Text(crewMember.astronaut.name)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
            }
        }
    }
}

struct MissionCrewView_Previews: PreviewProvider {
    
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionCrewView(mission: missions[4], astronauts: astronauts)
    }
}
