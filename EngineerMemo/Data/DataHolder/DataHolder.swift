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
}
