//
//  FeedbackCopyApp.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/19/23.
//

import SwiftUI

@main
struct FeedbackCopyApp: App {
    /// Make an instance of dataController and share it everywhere
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            NavigationSplitView { // it says this can be 2 or 3 columns
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
