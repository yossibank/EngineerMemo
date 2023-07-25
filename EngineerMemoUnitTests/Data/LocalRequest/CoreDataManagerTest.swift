import CoreData
@testable import EngineerMemo
import XCTest

final class CoreDataManagerTest: XCTestCase {
    override func tearDown() {
        super.tearDown()

        resetUserDefaults()

        CoreDataManager.shared.injectInMemoryPersistentContainer()
    }

    func test_migrate_参照するsqliteのパスがAppGroupへと変更されること() {
        // arrange
        let shared = CoreDataManager.shared
        let oldStoreURL = shared.backgroundContext.persistentStoreCoordinator!.persistentStores.first!.url!
        let newStoreURL = shared.newStoreURL

        XCTAssertFalse(oldStoreURL.absoluteString.contains("/AppGroup/"))

        // act
        shared.migrate(
            oldStoreURL: oldStoreURL,
            newStoreURL: newStoreURL
        )

        let migratedURL = shared.backgroundContext.persistentStoreCoordinator!.persistentStores.first!.url!

        // assert
        XCTAssertTrue(migratedURL.absoluteString.contains("/AppGroup/"))
    }
}
