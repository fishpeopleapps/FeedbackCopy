//
//  ContentView.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/19/23.
//

import SwiftUI

// Center View
struct ContentView: View {
    // gives us access to our data controller
    @EnvironmentObject var dataController: DataController
    /// If there is a tag, filter by that, if not, do a regular fetch request
    var issues: [Issue] {
        let filter = dataController.selectedFilter ?? .all
        var allIssues: [Issue]
        // if we have a tag attached to the filter, use that
        if let tag = filter.tag {
            allIssues = tag.issues?.allObjects as? [Issue] ?? []
        } else {
            // if we're here, there is no tag do a standard fetch request, which is 2 lines
            // first line
            let request = Issue.fetchRequest()
            // we're using this because we have MORE smart fitlers
            request.predicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            // second line
            allIssues = (try? dataController.container.viewContext.fetch(request)) ?? []
        }

        return allIssues.sorted()
    }
    // view
    var body: some View {
        VStack {
            // Here is where we are binding a selected to our selected issues
            List(selection: $dataController.selectedIssue) {
                ForEach(issues) { issue in
                    IssueRow(issue: issue)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Issues")
        }
        .padding()
    }
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = issues[offset]
            dataController.delete(item)
        }
    }
}
