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
    
    var body: some View {
        VStack(spacing: 10) {
            Text(entry.item.imageName)
                .font(.largeTitle)
            Text(entry.date, style: .time)
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct MyWidget2_Previews: PreviewProvider {
    static var previews: some View {
        MyWidget2EntryView(entry: ItemEntry(item: Item(
            name: "Rose",
            description: "I love you!",
            imageName: "🌹"))
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
