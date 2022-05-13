import SwiftUI

struct ContentView: View {
    
    let items = [
        Item(name: "Car", description: "I have a Honda", imageName: "🚗"),
        Item(name: "Apple", description: "Apple is my favorite fruit", imageName: "🍎"),
        Item(name: "Flag", description: "I'm from the United States", imageName: "🇺🇸")
    ]
    
    @AppStorage("item", store: UserDefaults(suiteName: "group.Cicimaya.SwiftUI-Widget"))
    var itemData: Data = Data()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            ForEach(items, id: \.name) { item in
                Button(action: {
                    guard let data = try? JSONEncoder().encode(item) else {
                        return
                    }
                    
                    itemData = data
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
