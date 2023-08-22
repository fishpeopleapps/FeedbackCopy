//
//  IssueRow.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/22/23.
//

import SwiftUI

struct IssueRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var issue: Issue
    var body: some View {
        NavigationLink(value: issue) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(issue.priority == 2 ? 1 : 0)
                VStack(alignment: .leading) {
                    Text(issue.issueTitle)
                        .font(.headline)
                        .lineLimit(1)
                    Text(issue.issueTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    // This would allocate space for two lines of text, even if they aren't filled
                    // .lineLimit(2...2
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(issue.issueCreationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                    if issue.completed {
                        Text("CLOSED")
                        // TODO: Oh this is cute! Explore this
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}
