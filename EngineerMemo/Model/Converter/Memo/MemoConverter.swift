/// @mockable
protocol MemoConverterInput {
    func convert(_ memo: Memo) -> MemoModelObject
}

struct MemoConverter: MemoConverterInput {
    func convert(_ memo: Memo) -> MemoModelObject {
        // NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        MemoModelObject(
            category: .init(rawValue: memo.category?.rawValue ?? .invalid),
            title: memo.title ?? .noSetting,
            content: memo.content ?? .noSetting,
            createdAt: memo.createdAt ?? .init(),
            identifier: memo.identifier
        )
    }
}
