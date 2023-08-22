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
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
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
            Section("Tags") {
                ForEach(tagFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                        // TODO: Note the use of .badge
                            .badge(filter.tag?.tagActiveIssues.count ?? 0)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar {
            Button {
                // This isn't working as expected, it's not deleting all of the data quicklike his
                dataController.deleteAll()
                // but it is after reopening?
                dataController.createSampleData()
            } label: {
                Label("Add Samples", systemImage: "flame")
            }
        }
    }
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
}
