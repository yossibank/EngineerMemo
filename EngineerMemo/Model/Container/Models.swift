enum Models {
    static func Memo() -> MemoModel {
        .init(
            memoConverter: MemoConverter(),
            errorConverter: AppErrorConverter()
        )
    }

    static func Profile() -> ProfileModel {
        .init(
            profileConverter: ProfileConverter(),
            errorConverter: AppErrorConverter()
        )
    }
}
