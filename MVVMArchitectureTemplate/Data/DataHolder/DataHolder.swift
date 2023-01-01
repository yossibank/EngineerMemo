enum DataHolder {
    @FileStorage(
        fileName: FileName.someFile.rawValue
    )
    static var someFile: [String]?

    @UserDefaultsStorage(
        UserDefaultsKey.sample.rawValue,
        defaultValue: .sample1
    )
    static var sample: UserDefaultsEnum.Sample
}
