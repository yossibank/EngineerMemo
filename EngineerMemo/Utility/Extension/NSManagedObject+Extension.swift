import CoreData
import UIKitHelper

extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        self.init(
            entity: NSEntityDescription.entity(
                forEntityName: Self.className,
                in: context
            )!,
            insertInto: context
        )
    }
}
