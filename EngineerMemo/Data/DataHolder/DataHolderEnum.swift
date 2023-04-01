import Foundation

extension DataHolder {
    enum ProfileIcon: Int, CaseIterable, UserDefaultsCompatible {
        case elephant
        case fox
        case octopus
        case panda
        case penguin
        case seal
        case sheep
    }

    enum ColorTheme: Int, CaseIterable, UserDefaultsCompatible {
        case system
        case light
        case dark
    }
}
