import Foundation

enum DataHolder {
    @FileStorage(
        fileName: FileName.someFile.rawValue
    )
    static var someFile: [String]?

    @UserDefaultsStorage(
        .sample,
        defaultValue: .sample1
    )
    static var sample: DataHolder.Sample

    @UserDefaultsStorage(
        .test,
        defaultValue: .test1
    )
    static var test: DataHolder.Test

    @UserDefaultsStorage(
        .string,
        defaultValue: ""
    )
    static var string: String

    @UserDefaultsStorage(
        .int,
        defaultValue: 0
    )
    static var int: Int

    @UserDefaultsStorage(
        .bool,
        defaultValue: false
    )
    static var bool: Bool

    @UserDefaultsStorage(
        .date,
        defaultValue: Date()
    )
    static var date: Date

    @UserDefaultsStorage(
        .optional,
        defaultValue: nil
    )
    static var optional: String?

    @UserDefaultsStorage(
        .optionalBool,
        defaultValue: nil
    )
    static var optionalBool: Bool?
}
