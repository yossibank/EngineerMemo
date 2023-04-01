import Foundation

enum DataHolder {
    @FileStorage(
        fileName: FileName.someFile.rawValue
    )
    static var someFile: [String]?

    @UserDefaultsStorage(
        .profileIcon,
        defaultValue: .penguin
    )
    static var profileIcon: DataHolder.ProfileIcon

    @UserDefaultsStorage(
        .colorTheme,
        defaultValue: .system
    )
    static var colorTheme: DataHolder.ColorTheme
}
