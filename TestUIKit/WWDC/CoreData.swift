//
//  CoreData.swift
//  TestUIKit
//
//  Created by Duck Sern on 7/3/26.
//

import Foundation

/// Persistent container: NSPersistentContainer:
/// - Model: NSManagedObjectModel
/// - Context: NSManagaedObjectContext ( command pattern ) mostly interact with
/// - Store coordinator: NSPersistentStoreCoordinator handle persist data
///
/// Query generations??
///
/// `automaticallyMergesChangesFromParent`: keep context upto date as changes saved by sibling
///
/// also store request and interaction must done in context's queue
///
/// Batch insertions: `NSBatchInsertRequest`
/// - Not generate `contextDidSave` noti
///
/// Use KVO to observe change in coredata model
///
/// Fetch many objects
/// - Batched fetching: `fetchRequest.fetchBatchSize = 50`
/// - Can dispaly fetch result using NSDiffableDataSource
///
/// Derived Atrributes: CoreData-managed metadata support denormalization
/// - Defined in managed object model
///
/// Testing:
/// - Using in memory stores:
/// `container.persistentStoreDescriptions.first.url = URL(fileURLWithPath: "/dev/null)`
/// - Can not be share between coordinator
/// - `appendingPathComponent` to above url, allow coordinator in same process share receive remote notification, sahre same store
///
