import SwiftUI

struct RecentWardrobeView: View {
    @Bindable var store = WardrobeStore.shared
    @Bindable var themeManager = TinaThemeManager.shared
    
    var onSeeAll: () -> Void
    
    // Grille 2 colonnes sur iPhone, 4 colonnes sur écran large
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 14),
            GridItem(.flexible(), spacing: 14)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // ── En-tête de section ─────────────────────────────
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("VOTRE STYLE")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1.8)
                        .foregroundStyle(themeManager.mutedColor)
                    
                    Text("Récemment ajoutées")
                        .font(.custom("Georgia", size: 28))
                        .fontWeight(.medium)
                        .foregroundStyle(themeManager.inkColor)
                }
                
                Spacer()
                
                Button {
                    onSeeAll()
                } label: {
                    HStack(spacing: 4) {
                        Text("Voir toute la garde-robe")
                            .font(.system(size: 12, weight: .medium))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(themeManager.inkColor)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 10)
            
            // ── Grille d'articles ──────────────────────────────
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(store.filteredItems.prefix(6)) { item in
                    clothingCard(item: item)
                }
            }
        }
    }
    
    private func clothingCard(item: ClothingItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack {
                if let urlString = item.imageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 160)
                                .clipped()
                                .grayscale(themeManager.activeTheme.isMonochrome ? 1.0 : 0.0)
                        case .failure:
                            fallbackImage(for: item)
                        case .empty:
                            Rectangle()
                                .fill(themeManager.canvasColor)
                                .frame(height: 160)
                                .overlay(ProgressView())
                        @unknown default:
                            fallbackImage(for: item)
                        }
                    }
                } else {
                    fallbackImage(for: item)
                }
            }
            .frame(height: 160)
            .clipped()
            
            // Textes
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
            }
            .padding(14)
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
    
    private func fallbackImage(for item: ClothingItem) -> some View {
        Rectangle()
            .fill(themeManager.canvasColor)
            .frame(height: 160)
            .overlay(
                Image(systemName: item.category.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(themeManager.mutedColor)
            )
    }
}
