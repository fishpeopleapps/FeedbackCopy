//
//  IssueView.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/22/23.
//

import SwiftUI

struct IssueView: View {
    @EnvironmentObject var dataController: DataController
    // This is going to be our "default value" for a selected issue, so something appears when detail view is presented
    @ObservedObject var issue: Issue
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    // TODO: The 'prompt' is helpful and I should use it in Calculate it!
                    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
                        .font(.title)
                    // TODO: The ** makes it bold! (add both of these to my code notes book)
                    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
                    Text("**Status:** \(issue.issueStatus)")
                        .foregroundStyle(.secondary)
                }
                Picker("Priority", selection: $issue.priority) {
                    Text("Low").tag(Int16(0)) // TODO: This is cool as well! It's kind of like mapping a string to an int
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                }
                Menu {
                    // show selected tags first
                    ForEach(issue.issueTags) { tag in
                        Button {
                            issue.removeFromTags(tag) // this is auto provided to us from CoreData
                        } label: {
                            Label(tag.tagName, systemImage: "checkmark")
                        }
                    }
                    // if we're here, show unselected tags
                    let otherTags = dataController.missingTags(from: issue)
                    // if there's anything in here
                    if otherTags.isEmpty == false {
                        Divider()
                        Section("Add Tags") {
                            // loops over unused tags
                            ForEach(otherTags) { tag in
                                Button(tag.tagName) {
                                    issue.addToTags(tag)
                                }
                            }
                        }
                    }
                    // We're doing a label down here instead of a parameter after menu so we can customize the text
                    // TODO: Where else can I use this? I like it, add to notes
                } label: {
                    Text(issue.issueTagsList)
                        .multilineTextAlignment(.leading )
                    // there is another bug that shows Ta... when you click multiple tags, this is a workaround
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(nil, value: issue.issueTagsList)
                }
            }
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    TextField(
                        "Description",
                        text: $issue.issueContent,
                        prompt: Text("Enter the issue description here"),
                        axis: .vertical)
                }
            }
        }
        // there's some sort of bug that lets them edit a deleted issue, this is a workaround for that
        .disabled(issue.isDeleted)
    }
}
