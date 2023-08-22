//
//  Tag-CoreDataHelper.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/22/23.
//

import Foundation

/// This file is created to deal with the CoreData optionals in one area
/// so we do not have to use nil coalescing in multiple spots
/// the get/set allow us to modify these properties directly
extension Tag {
    var tagID: UUID {
        id ?? UUID()
    }
    var tagName: String {
        name ?? ""
    }
    var tagActiveIssues: [Issue] {
        let result = issues?.allObjects as? [Issue] ?? []
        return result.filter { $0.completed == false }
    }
    /// Example just for testing during production
    static var example: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let tag = Tag(context: viewContext)
        tag.id = UUID()
        tag.name = "Tag Name Example"
        return tag
    }
}
/// This allows us to filter items properly
extension Tag: Comparable {
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.tagName.localizedLowercase
        let right = rhs.tagName.localizedLowercase
        if left == right {
            // meaningless comparison but it ensure stability
            return lhs.tagID.uuidString < rhs.tagID.uuidString
        } else {
            return left < right
        }
    }
}
