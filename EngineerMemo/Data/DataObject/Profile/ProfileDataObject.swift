import CoreData

@objc(Profile)
final class Profile: NSManagedObject {
    @NSManaged var address: String?
    @NSManaged var birthday: Date?
    @NSManaged var email: String?
    @NSManaged var gender: NSNumber?
    @NSManaged var identifier: String
    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
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
            .init(rawValue: gender?.intValue ?? .invalid)
        }
        set {
            guard let value = newValue?.rawValue else {
                return
            }

            gender = .init(value: value)
        }
    }
}

extension Profile: Identifiable, IdentifableManagedObject {}
