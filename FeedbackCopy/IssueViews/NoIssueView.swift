//
//  NoIssueView.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/22/23.
//

import SwiftUI
// There's no VStack in the body - he says this will be done by the parent view??
struct NoIssueView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        Text("No Issue Selected")
            .font(.title)
            .foregroundStyle(.secondary)
        Button("New Issue") {
            // make a new issue
        }
    }
}
