//
//  DetailView.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/19/23.
//

import SwiftUI

// Right most view
// Show IssueView or NoIssueView depending on the correct scenario
struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        VStack {
            if let issue = dataController.selectedIssue {
                IssueView(issue: issue)
            } else {
                NoIssueView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
