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
}
