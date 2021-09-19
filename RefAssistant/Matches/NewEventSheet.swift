//
//  NewEventSheet.swift
//  NewEventSheet
//
//  Created by Владимир Муравьев on 30.08.2021.
//

import SwiftUI

struct NewEventSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State private var type = "Goal"
    @State private var author: Player = Player()
    @ObservedObject var match: Match
    var moment: GameTimer
    var isHomeTeamEvent: Bool
    
    var players: [Player] {
        if isHomeTeamEvent {
        if let allPlayers = match.homeTeam?.players?.allObjects as? [Player] {
            return allPlayers
        } else { return [] }
        } else {
            if let allPlayers = match.visitTeam?.players?.allObjects as? [Player] {
                return allPlayers
            } else { return [] }
        }
    }

    var body: some View {
        
        NavigationView {
        Form {
            
            Section {
            Text("Choose event")
            Picker("Event", selection: $type) {
                ForEach(Event.possibleEvents, id: \.self) { eventName in
                    Text(eventName)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Picker("Choose event's author", selection: $author) {
                    ForEach(players) { player in
                        
                        Text(player.fullName ?? "").tag(player)
                    }
                }
            }
            
            Button {
  
                let newEvent = Event(context: moc)
                newEvent.author = author
                newEvent.team = isHomeTeamEvent ? match.homeTeam : match.visitTeam
                newEvent.type = type
                newEvent.gameTimer = moment
                newEvent.date = Date()
                
                newEvent.match = match
                
                 try? moc.save()
                
                 presentationMode.wrappedValue.dismiss()
                
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            }
            .disabled(author.managedObjectContext == nil)

        }
            
        }
        
        
    }
}

