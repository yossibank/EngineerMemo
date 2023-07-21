import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .init(
            date: .init(),
            configuration: .init()
        )
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Entry) -> Void
    ) {
        let entry = Entry(
            date: .init(),
            configuration: configuration
        )

        completion(entry)
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        var entries: [Entry] = []

        let currentDate = Date()

        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = Entry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
