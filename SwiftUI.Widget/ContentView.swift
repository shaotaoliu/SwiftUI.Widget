import SwiftUI
import WidgetKit

struct ContentView: View {
    
    let items = [
        Item(name: "Car", description: "I have a Honda", imageName: "π"),
        Item(name: "Apple", description: "Apple is my favorite fruit", imageName: "π"),
        Item(name: "Flag", description: "I'm from the United States", imageName: "πΊπΈ")
    ]
    
    @AppStorage("item", store: UserDefaults(suiteName: "group.Cicimaya.SwiftUI-Widget"))
    var itemData: Data = Data()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            ForEach(items, id: \.name) { item in
                Button(action: {
                    refreshWidget(item: item)
                }, label: {
                    HStack(spacing: 20) {
                        Text(item.imageName)
                            .font(.system(size: 50))
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.name)
                                .font(.title2.bold())
                                .foregroundColor(.indigo)
                            
                            Text(item.description)
                                .font(.title3)
                                .foregroundColor(.teal)
                        }
                    }
                })
            }
        }
    }
    
    private func refreshWidget(item: Item) {
        guard let data = try? JSONEncoder().encode(item) else {
            return
        }
        
        itemData = data
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

