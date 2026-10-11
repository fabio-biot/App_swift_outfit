import SwiftUI

struct FullWardrobeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store = WardrobeStore.shared
    @Bindable var themeManager = TinaThemeManager.shared
    
    @State private var selectedCategory: Category? = nil
    
    private var displayedItems: [ClothingItem] {
        var result = store.filteredItems
        if let selectedCategory {
            result = result.filter { $0.category == selectedCategory }
        }
        return result
    }
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 14),
            GridItem(.flexible(), spacing: 14)
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // ── Filtres Catégories ─────────────────────────────
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            categoryPill(title: "Tous", isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                            }
                            
                            ForEach(Category.allCases, id: \.self) { cat in
                                categoryPill(title: cat.rawValue, isSelected: selectedCategory == cat) {
                                    selectedCategory = cat
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
                    
                    // ── Grille ─────────────────────────────────────────
                    if displayedItems.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tshirt")
                                .font(.system(size: 42))
                                .foregroundStyle(themeManager.mutedColor)
                            
                            Text("Aucune pièce trouvée")
                                .font(.custom("Georgia", size: 18))
                                .foregroundStyle(themeManager.inkColor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(displayedItems) { item in
                                itemCard(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 30)
            }
            .background(themeManager.canvasColor.ignoresSafeArea())
            .navigationTitle("Ma Garde-Robe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundStyle(themeManager.inkColor)
                }
            }
        }
    }
    
    private func categoryPill(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(
                    isSelected ?
                    (themeManager.activeTheme.isDark ? Color.black : Color.white) :
                    themeManager.mutedColor
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? themeManager.accentColor : themeManager.panelColor)
                        .overlay(
                            Capsule().stroke(isSelected ? Color.clear : themeManager.borderColor, lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
    }
    
    private func itemCard(item: ClothingItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                if let urlString = item.imageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                                .grayscale(themeManager.activeTheme.isMonochrome ? 1.0 : 0.0)
                        default:
                            fallback(for: item)
                        }
                    }
                } else {
                    fallback(for: item)
                }
            }
            .frame(height: 180)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.category.rawValue.uppercased())
                    .font(.system(size: 9, weight: .bold))
                    .tracking(1.4)
                    .foregroundStyle(themeManager.mutedColor)
                
                Text(item.name)
                    .font(.custom("Georgia", size: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(themeManager.inkColor)
                    .lineLimit(1)
                
                if let brand = item.brand {
                    Text(brand)
                        .font(.system(size: 11))
                        .foregroundStyle(themeManager.mutedColor)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(themeManager.panelColor)
        }
        .background(themeManager.panelColor)
        .clipShape(RoundedRectangle(cornerRadius: themeManager.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.cardRadius)
                .stroke(themeManager.borderColor, lineWidth: 1)
        )
    }
    
    private func fallback(for item: ClothingItem) -> some View {
        Rectangle()
            .fill(themeManager.panelColor)
            .frame(height: 180)
            .overlay(
                Image(systemName: item.category.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(themeManager.mutedColor)
            )
    }
}
