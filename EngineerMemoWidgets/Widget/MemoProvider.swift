import WidgetKit

struct MemoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> MemoEntry {
        .init(
            date: .init(),
            configuration: .init()
        )
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (MemoEntry) -> Void
    ) {
        let entry = MemoEntry(
            date: .init(),
            configuration: configuration
        )

        completion(entry)
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<MemoEntry>) -> Void
    ) {
        var entries: [Entry] = []

        let currentDate = Date()

        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MemoEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
