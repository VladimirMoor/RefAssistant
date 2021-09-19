//
//  RefAssistantApp.swift
//  RefAssistant
//
//  Created by Владимир Муравьев on 12.09.2021.
//

import SwiftUI

@main
struct MatchScoreApp: App {
    
    let coreDataManager = CoreDataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.context)
        }
    }
}
