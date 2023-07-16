import Foundation

extension DataHolder {
    enum ColorTheme: Int, CaseIterable, UserDefaultsCompatible {
        case system
        case light
        case dark
    }

    enum ProfileIcon: Int, CaseIterable, UserDefaultsCompatible {
        case elephant
        case fox
        case octopus
        case panda
        case penguin
        case seal
        case sheep
    }

    enum ProfileProjectSortType: Int, CaseIterable, UserDefaultsCompatible {
        case descending
        case ascending
    }
}
