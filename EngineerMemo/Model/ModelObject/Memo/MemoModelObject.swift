import Foundation

struct MemoModelObject: Hashable {
    var title: String?
    var content: String?
    var identifier: String
}

extension MemoModelObject {
    func dataInsert(
        _ memo: Memo,
        isNew: Bool
    ) {
        memo.title = title
        memo.content = content

        if isNew {
            memo.identifier = UUID().uuidString
        }
    }
}
