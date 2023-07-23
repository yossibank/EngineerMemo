import Foundation

enum DataHolder {
    @UserDefaultsStorage(
        .isShowAppReview,
        defaultValue: false
    )
    static var isShowAppReview: Bool

    @UserDefaultsStorage(
        .isCoreDataMigrated,
        defaultValue: false
    )
    static var isCoreDataMigrated: Bool

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

    @UserDefaultsStorage(
        .profileProjectSortType,
        defaultValue: .descending
    )
    static var profileProjectSortType: DataHolder.ProfileProjectSortType
}

extension DataHolder {
    @FileStorage(
        fileName: FileName.someFile.rawValue
    )
    static var someFile: [String]?
}
