import CoreData

@objc(Profile)
final class Profile: NSManagedObject {
    @NSManaged var address: String?
    @NSManaged var age: NSNumber?
    @NSManaged var email: String?
    @NSManaged var gender: NSNumber?
    @NSManaged var identifier: String
    @NSManaged var name: String?
    @NSManaged var phoneNumber: NSNumber?
    @NSManaged var station: String?
}

extension Profile {
    enum Gender: Int {
        case man
        case woman
        case other
    }

    var genderEnum: Gender? {
        get {
            Gender(rawValue: gender?.intValue ?? -1)
        }
        set {
            guard let value = newValue?.rawValue else {
                return
            }

            gender = NSNumber(value: value)
        }
    }
}

extension Profile: Identifiable, IdentifableManagedObject {}
