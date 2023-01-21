enum Models {
    static func Profile() -> ProfileModel {
        .init(
            profileConverter: ProfileConverter(),
            errorConverter: AppErrorConverter()
        )
    }

    static func Sample() -> SampleModel {
        .init(
            apiClient: APIClient(),
            sampleConverter: SampleConverter(),
            errorConverter: AppErrorConverter()
        )
    }
}
