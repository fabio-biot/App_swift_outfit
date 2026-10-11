import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var themeManager = TinaThemeManager.shared
    
    @State private var name = ""
    @State private var category = Category.top
    @State private var brand = ""
    @State private var imageUrl = ""
    
    var onSave: (ClothingItem) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("DÉTAILS DU VÊTEMENT").font(.system(size: 11, weight: .bold))) {
                    TextField("Nom de la pièce (ex: Chemise en popeline)", text: $name)
                    
                    Picker("Catégorie", selection: $category) {
                        ForEach(Category.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    
                    TextField("Marque (ex: Sézane, Sandro)", text: $brand)
                }
                
                Section(header: Text("PHOTO OU VISUEL").font(.system(size: 11, weight: .bold))) {
                    TextField("Lien image (URL facultative)", text: $imageUrl)
                }
            }
            .navigationTitle("Ajouter une pièce")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundStyle(themeManager.mutedColor)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let newItem = ClothingItem(
                            name: name,
                            category: category,
                            imageUrl: imageUrl.isEmpty ? nil : imageUrl,
                            brand: brand.isEmpty ? nil : brand
                        )
                        onSave(newItem)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(themeManager.accentColor)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
