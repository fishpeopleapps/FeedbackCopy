//
//  Issue-CoreDataHelper.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/22/23.
//

import Foundation

/// This file is created to deal with the CoreData optionals in one area
/// so we do not have to use nil coalescing in multiple spots
/// the get/set allow us to modify these properties directly
extension Issue {
    var issueTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }
    var issueContent: String {
        get { content ?? "" }
        set { content = newValue }
    }
    /// get/set isn't required here because it can be assigned to directly
    var issueCreationDate: Date {
        creationDate ?? .now
    }
    var issueModificationDate: Date {
        modificationDate ?? .now
    }
    /// Gets all of its tags neatly sorted according to the specifications below
    var issueTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    /// This is to create a nice display on the menu so it shows the tag names in one string
    var issueTagsList: String {
        // if we have no tags (shouldn't happen)
        guard let tags else { return "No tags" }
        if tags.count == 0 {
            return "No tags"
        } else {
            // if we're here, we have some tags to work with
            return issueTags.map(\.tagName).formatted()
        }
        
    }
    var issueStatus: String {
        if completed {
            return "Closed"
        } else {
            return "Open"
        }
    }
    /// Example just for testing during production
    static var example: Issue {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let issue = Issue(context: viewContext)
        issue.title = "Example Issue"
        issue.content = "This is an example issue"
        issue.priority = 2
        issue.creationDate = .now
        return issue
    }
}
/// Here we are saying we want our puddles to be sorted by puddle type, but if the puddles
/// have the same type, we want them to be sorted by their modification date
extension Issue: Comparable {
    public static func < (lhs: Issue, rhs: Issue) -> Bool {
        let left = lhs.issueTitle.localizedLowercase
        let right = rhs.issueTitle.localizedLowercase
        if left == right {
            return lhs.issueCreationDate < rhs.issueCreationDate
        } else {
            return left < right
        }
    }
}
