//
//  NewMatchCreateView.swift
//  NewMatchCreateView
//
//  Created by Владимир Муравьев on 27.08.2021.
//

import SwiftUI

struct NewMatchCreateView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Team.entity(), sortDescriptors: []) var teams: FetchedResults<Team>
    @State private var homeTeam: Team = Team()
    @State private var visitTeam: Team = Team()
    @State private var match: Match = Match()


    
    let oneHalfDurations = [1, 5, 10, 15, 20, 30, 45, 60]
    @State private var oneHalfDuration = 45
    @State private var isShowMatchView = false
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack {
            
            if teams.count < 2 {
                Text("Create at least two teams in 'Teams' tab")
                    .font(.title3)
                    .foregroundColor(Color.gray.opacity(0.5))
            } else {
                
                NavigationLink(destination: CurrentMatchView(match: match, newMatchCreateViewIsPresented: $isPresented), isActive: $isShowMatchView) {
                        EmptyView()
                    }
                
                Form {

                    Picker("Home Team", selection: $homeTeam) {
                        ForEach(teams) { team in
                            Text(team.name ?? "").tag(team)
                        }
                    }

                    Picker("Visit Team", selection: $visitTeam) {
                        ForEach(teams) { team in
                            Text(team.name ?? "").tag(team)
                        }
                    }

                    Picker("One Half Duration(in minutes)", selection: $oneHalfDuration) {
                        ForEach(oneHalfDurations, id: \.self) { duration in
                            Text("\(duration) min.")
                        }
                    }

                    Section {
                        Button {

                            match = Match(context: moc)
                            match.oneHalfDuration = Int16(oneHalfDuration)
                            match.homeTeam = homeTeam
                            match.visitTeam = visitTeam
                            match.startDate = Date()
                            
                            try? moc.save()

                            isShowMatchView = true

                        } label: {
                            Text("Start the Game!")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(homeTeam.managedObjectContext == nil || visitTeam.managedObjectContext == nil)

                    }

                }
                
            }
                
        }
        .navigationTitle("Create Match")

        
        }

    }



