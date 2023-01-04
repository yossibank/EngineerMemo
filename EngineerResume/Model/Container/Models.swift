enum Models {
    static func Sample() -> SampleModel {
        .init(
            apiClient: APIClient(),
            sampleConverter: SampleConverter(),
            errorConverter: AppErrorConverter()
        )
    }
}
