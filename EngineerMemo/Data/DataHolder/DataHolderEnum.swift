import Foundation

extension DataHolder {
    enum Sample: Int, CaseIterable, UserDefaultsCompatible {
        case sample1
        case sample2
        case sample3
    }

    enum Test: Int, CaseIterable, UserDefaultsCompatible {
        case test1
        case test2
        case test3
    }
}
