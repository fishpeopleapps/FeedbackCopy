//
//  DataController.swift
//  FeedbackCopy
//
//  Created by Kimberly Brewer on 8/19/23.
//

import CoreData

/// Exists to be watched
class DataController: ObservableObject {
    /// Handles loading, managing, saving, (local data) and synchronizing to the cloud
    let container: NSPersistentCloudKitContainer
    /// Place to store users current selection of filter (frog)
    @Published var selectedFilter: Filter? = Filter.all
    /// We need to see if there is a currently selected issue, we'll house that variable here
    /// This will determine which view (NoIssueView or IssueView) that DetailView should show
    @Published var selectedIssue: Issue? 
    /// Pre-made data controller, suitable for SwiftUI Views
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    /// Load our main data model
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        /// If true - make/save data in RAM, so it's temporary, for testing purposes
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        // ------This is for monitoring changes and update our UI accordingly (kind of how Reminders works)
        // This is so iCloud updates while the app is being used
        container.viewContext.automaticallyMergesChangesFromParent = true
        // How are we merging changes if updates are happening in multiple places?
        // Tell coreData to update changes locally first, then remotely
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        // See func remoteStoreChanged
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged)
        // -------
        /// This is the long term storage
        container.loadPersistentStores { storeDescription, error in
            /// Couldn't load data
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    // ----This is the final touch for ensuring our changes will get updated (see above line 29)
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    /// Creates sample data to be used in testing and development, filled with default data
    func createSampleData() {
        /// ViewContext is the pool of data that's in RAM right now - whatever is loaded
        /// from disk, that is live in memory right now is our viewContext
        let viewContext = container.viewContext
        // Puddle
        for tagNum in 1...5 {
            let tag = Tag(context: viewContext)
            tag.id = UUID()
            tag.name = "Tag \(tagNum)"
            for issueNum in 1...10 {
                let issue = Issue(context: viewContext)
                issue.title = "Issue \(tagNum)-\(issueNum)"
                issue.content = "Issue Description goes here"
                issue.creationDate = .now
                issue.completed = Bool.random()
                issue.priority = Int16.random(in: 0...2)
                tag.addToIssues(issue)
            }
        }
        /// Write all new objects out to persistent storage (could be permanent or temporary in /dev/null
        try? viewContext.save()
    }
    /// Save on command if there are changes, so we aren't just saving willy nilly
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    /// For deleting a project or tag, then saving afterward
    /// - Parameter object: Takes either a Project or Tag
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    /// We're creating a request to delete batch items, we're getting the object IDs back,
    /// merges changes back into our viewContext (this is mostly used for development)
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
        delete(request1)
        let request2: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request2)
        save()
    }
    
    /// Finds all tags that are not already assigned to the specified issue
    /// - Parameter issue: The issue we're going to find the tags for
    /// - Returns: A sorted array of unassigned tags
    func missingTags(from issue: Issue) -> [Tag] {
        // make a request for all tags, and put them into an array
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []
        // make that array into a set
        let allTagsSet = Set(allTags)
        // find the difference, ie what tags do we not have for the issue
        let difference = allTagsSet.symmetricDifference(issue.issueTags)
        // now issues is a Set, but if we call .sorted() then it's an array ;)
        return difference.sorted()
    }
}
