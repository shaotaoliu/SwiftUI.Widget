import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    @AppStorage("item", store: UserDefaults(suiteName: "group.Cicimaya.SwiftUI-Widget"))
    var itemData: Data = Data()
    
    func placeholder(in context: Context) -> ItemEntry {
        ItemEntry(item: Item(name: "Rose", description: "I love you!", imageName: "🌹"))
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ItemEntry) -> ()) {
        guard let entry = getItemEntry() else {
            return
        }
        
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        guard let entry = getItemEntry() else {
            return
        }

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    private func getItemEntry() -> ItemEntry? {
        guard let item = try? JSONDecoder().decode(Item.self, from: itemData) else {
            return nil
        }
        
        return ItemEntry(item: item)
    }
}

struct ItemEntry: TimelineEntry {
    let date = Date()
    let item: Item
}

struct MyWidget2EntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            MyWidgetSmallView(entry: entry)

        case .systemMedium:
            MyWidgetMediumView(entry: entry)

        default:
            MyWidgetLargeView(entry: entry)
        }
    }
}

struct MyWidgetSmallView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 10) {
            Text(entry.item.imageName)
                .font(.largeTitle)
            
            Text(entry.date, style: .time)
        }
    }
}

struct MyWidgetMediumView : View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack(spacing: 30) {
            Text(entry.item.imageName)
                .font(.system(size: 50))
            
            VStack(spacing: 10) {
                Text(entry.item.name)
                    .font(.title3.bold())
                
                Text(entry.item.description)
            }
        }
    }
}

struct MyWidgetLargeView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 20) {
            Text(entry.item.imageName)
                .font(.system(size: 80))
            
            Text(entry.item.name)
                .font(.title.bold())
            
            Text(entry.item.description)
                .font(.title3)
        }
    }
}

@main
struct MyWidget2: Widget {
    let kind: String = "MyWidget2"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            MyWidget2EntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct MyWidget2_Previews: PreviewProvider {
    static let entry = ItemEntry(item: Item(
        name: "Rose",
        description: "I love you!",
        imageName: "🌹"
    ))
    
    static var previews: some View {
        Group {
            MyWidget2EntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MyWidget2EntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MyWidget2EntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
