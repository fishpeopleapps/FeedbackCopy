//
//  SidebarView.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/19/23.
//

import SwiftUI

// Primary View
struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilters: [Filter] = [.all, .recent]
    // Load all of the tags that we have, fetch request ensure info is kept up to date
    // tags aren't enough, we need filters as well
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.id ?? UUID(), name: tag.name ?? "No Name", icon: "tag", tag: tag)
        }
    }
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            Section("Tags")  {
                ForEach(tagFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
        }
        .toolbar {
            Button {
                dataController.deleteAll() // This isn't working as expected, it's not deleting all of the data quicklike his
                // but it is after reopening?
                dataController.createSampleData()
            } label: {
                Label("Add Samples", systemImage: "flame")
                
            }
        }
    }
}
