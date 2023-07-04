import Foundation

enum DataHolder {
    @UserDefaultsStorage(
        .isShowAppReview,
        defaultValue: false
    )
    static var isShowAppReview: Bool

    @UserDefaultsStorage(
        .colorTheme,
        defaultValue: .system
    )
    static var colorTheme: DataHolder.ColorTheme

    @UserDefaultsStorage(
        .profileIcon,
        defaultValue: .penguin
    )
    static var profileIcon: DataHolder.ProfileIcon
}

extension DataHolder {
    @FileStorage(
        fileName: FileName.someFile.rawValue
    )
    static var someFile: [String]?
}
