import SwiftUI

struct OutfitGeneratorView: View {
    @Bindable var store = WardrobeStore.shared
    @Bindable var themeManager = TinaThemeManager.shared
    
    @State private var isRefreshing: Bool = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        let concept = themeManager.activeTheme
        
        VStack(alignment: themeManager.activeTheme == .solaire ? .center : .leading, spacing: 20) {
            
            // Adaptatif selon la taille de l'écran (iPhone vs iPad/Mac)
            ViewThatFits(in: .horizontal) {
                // Écran large (2 colonnes)
                HStack(alignment: .center, spacing: 28) {
                    if themeManager.activeTheme == .cobalt {
                        // Pour le thème Cobalt (LOOKLAB), ordre inversé comme dans le CSS
                        outfitCard
                            .frame(maxWidth: 420)
                        copyAndControls(concept: concept)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        copyAndControls(concept: concept)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        outfitCard
                            .frame(maxWidth: 420)
                    }
                }
                .padding(32)
                
                // Écran mobile (vertical)
                VStack(alignment: themeManager.activeTheme == .solaire ? .center : .leading, spacing: 24) {
                    copyAndControls(concept: concept)
                        .padding(.horizontal, 22)
                        .padding(.top, 24)
                    
                    outfitCard
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: themeManager.cardRadius)
                .fill(themeManager.generatorBgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: themeManager.cardRadius)
                        .stroke(themeManager.borderColor, lineWidth: themeManager.activeTheme == .editorial ? 1 : 0)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: themeManager.cardRadius))
    }
    
    // MARK: - Colonne Textes & Contrôles
    private func copyAndControls(concept: TinaThemeId) -> some View {
        VStack(alignment: themeManager.activeTheme == .solaire ? .center : .leading, spacing: 14) {
            
            // Kicker
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12))
                
                Text(concept.label.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.8)
            }
            .foregroundStyle(themeManager.accentColor)
            
            // Titre Principal
            Text(concept.title)
                .font(.custom("Georgia", size: 38))
                .fontWeight(.medium)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .foregroundStyle(themeManager.inkColor)
                .multilineTextAlignment(themeManager.activeTheme == .solaire ? .center : .leading)
            
            // Description
            Text(concept.themeDescription)
                .font(.system(size: 14))
                .lineSpacing(4)
                .foregroundStyle(themeManager.mutedColor)
                .multilineTextAlignment(themeManager.activeTheme == .solaire ? .center : .leading)
            
            // Question Occasion
            Text("Quelle est l’occasion ?")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(themeManager.inkColor)
                .padding(.top, 10)
            
            // Grille de pilules
            HStack(spacing: 8) {
                ForEach(store.availableOccasions, id: \.self) { occasion in
                    let isSelected = store.selectedOccasion == occasion
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            store.selectedOccasion = occasion
                        }
                    } label: {
                        Text(occasion)
                            .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                            .foregroundStyle(
                                isSelected ?
                                (themeManager.activeTheme.isDark ? Color.black : Color.white) :
                                themeManager.mutedColor
                            )
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(
                                        isSelected ?
                                        themeManager.accentColor :
                                        themeManager.canvasColor.opacity(0.8)
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                isSelected ? Color.clear : themeManager.borderColor,
                                                lineWidth: 1
                                            )
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Bouton Générer
            Button {
                triggerGenerate()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                    
                    Text(concept.action)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(themeManager.activeTheme.isDark ? Color.black : Color.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: themeManager.buttonRadius)
                        .fill(themeManager.accentColor)
                        .shadow(color: themeManager.accentColor.opacity(0.3), radius: 10, y: 5)
                )
            }
            .buttonStyle(.plain)
            .padding(.top, 10)
        }
    }
    
    // MARK: - Carte de la Tenue
    private var outfitCard: some View {
        let outfit = store.currentOutfit
        
        return VStack(spacing: 0) {
            // Image avec badges et bouton cœur
            ZStack(alignment: .top) {
                AsyncImage(url: URL(string: outfit.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 340)
                            .clipped()
                            .grayscale(themeManager.activeTheme.isMonochrome ? 1.0 : 0.0)
                            .transition(.opacity)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 340)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 36))
                                    .foregroundStyle(themeManager.mutedColor)
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 340)
                            .overlay(ProgressView())
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 340)
                .background(Color.gray.opacity(0.1))
                
                // Badges en haut
                HStack {
                    // Match score
                    Text("\(outfit.matchScore)% match")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.6))
                        )
                    
                    Spacer()
                    
                    // Bouton Coeur
                    Button {
                        store.toggleLikeCurrentOutfit()
                    } label: {
                        Image(systemName: outfit.isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundStyle(outfit.isLiked ? Color(hex: "#A84E43") : Color(hex: "#4A514B"))
                            .frame(width: 38, height: 38)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.9))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(14)
            }
            
            // Bas de la carte avec titre et bouton régénérer
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("VOTRE TENUE")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1.4)
                        .foregroundStyle(themeManager.mutedColor)
                    
                    Text(outfit.title)
                        .font(.custom("Georgia", size: 22))
                        .fontWeight(.medium)
                        .foregroundStyle(themeManager.inkColor)
                    
                    Text("\(store.selectedOccasion) · \(outfit.piecesCount) pièces")
                        .font(.system(size: 12))
                        .foregroundStyle(themeManager.mutedColor)
                }
                
                Spacer()
                
                // Bouton Refresh
                Button {
                    triggerGenerate()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(themeManager.inkColor)
                        .rotationEffect(.degrees(rotationAngle))
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(themeManager.canvasColor)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(18)
            .background(themeManager.panelColor)
        }
        .background(themeManager.panelColor)
        .clipShape(RoundedRectangle(cornerRadius: themeManager.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.cardRadius)
                .stroke(themeManager.borderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(themeManager.activeTheme.isMonochrome ? 0 : 0.08), radius: 20, y: 8)
    }
    
    private func triggerGenerate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            rotationAngle += 360
        }
        store.generateNextOutfit()
    }
}
