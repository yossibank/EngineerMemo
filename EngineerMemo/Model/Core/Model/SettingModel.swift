import Foundation

/// @mockable
protocol SettingModelInput {
    func updateColorTheme(_ value: Int)
}

struct SettingModel: SettingModelInput {
    func updateColorTheme(_ value: Int) {
        DataHolder.colorTheme = .init(rawValue: value) ?? .system
    }
}
