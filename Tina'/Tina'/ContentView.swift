import SwiftUI

struct ContentView: View {
    // @State : Cette variable est "vivante". Si on ajoute un item, la vue se redessine.
    @State private var wardrobe: [ClothingItem] = [
        ClothingItem(name: "T-Shirt Blanc", category: .top),
        ClothingItem(name: "Jean Bleu", category: .bottom),
        ClothingItem(name: "Baskets", category: .shoes),
        ClothingItem(name: "Veste en Cuir", category: .outerwear)
    ]
    
    @State private var showingAddItem = false
    
    var body: some View {
        NavigationStack {
            List(wardrobe) { item in
                HStack {
                    // Cercle avec l'icône
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 40)
                        Image(systemName: item.category.icon)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Ma Garde-Robe")
            .toolbar {
                Button {
                    showingAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView { newItem in
                    wardrobe.append(newItem)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
