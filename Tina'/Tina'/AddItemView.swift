import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var category = Category.top
    
    var onSave: (ClothingItem) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Détails du vêtement")) {
                    TextField("Nom (ex: MARTINAAAAAAAAAAA)", text: $name)
                    
                    Picker("Catégorie", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Nouveau Vêtement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let newItem = ClothingItem(name: name, category: category)
                        onSave(newItem)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddItemView { _ in }
}
