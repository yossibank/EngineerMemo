enum Models {
    static func Profile() -> ProfileModel {
        .init(
            profileConverter: ProfileConverter(),
            errorConverter: AppErrorConverter()
        )
    }
}
