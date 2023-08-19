//
//  Filter.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/19/23.
//

import Foundation

import SwiftUI
// Filter Frog
struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?

    static var all = Filter(
        id: UUID(),
        name: "All Issues",
        icon: "tray"
    )
    static var recent = Filter(
        id: UUID(),
        name: "Recent Issues",
        icon: "clock",
        minModificationDate: .now.addingTimeInterval(86400 * -7) // this means within the last week
    )
    // This is here so we can compare id numbers and sort them
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // This ensures the IDs are unique by comparing them
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
