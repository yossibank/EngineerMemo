import WidgetKit

struct MemoProvider: TimelineProvider {
    func placeholder(in context: Context) -> MemoEntry {
        .init(
            date: .init(),
            memoList: []
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (MemoEntry) -> Void
    ) {
        let entry = MemoEntry(
            date: .init(),
            memoList: WidgetModel.memoList
        )

        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<MemoEntry>) -> Void
    ) {
        let timeline = Timeline(
            entries: [
                MemoEntry(
                    date: .init(),
                    memoList: WidgetModel.memoList
                )
            ],
            policy: .atEnd
        )

        completion(timeline)
    }
}
