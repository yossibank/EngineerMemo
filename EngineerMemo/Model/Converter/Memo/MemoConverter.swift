/// @mockable
protocol MemoConverterInput {
    func convert(_ object: Memo) -> MemoModelObject
}

struct MemoConverter: MemoConverterInput {
    func convert(_ object: Memo) -> MemoModelObject {
        // NOTE: .init(...)生成は型チェックで時間がかかるため型指定して生成
        MemoModelObject(
            title: object.title ?? .noSetting,
            content: object.content ?? .noSetting,
            identifier: object.identifier
        )
    }
}
