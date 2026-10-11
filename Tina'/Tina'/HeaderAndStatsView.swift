import SwiftUI

struct HeaderAndStatsView: View {
    @Bindable var store = WardrobeStore.shared
    @Bindable var themeManager = TinaThemeManager.shared
    
    var onOpenSettings: () -> Void
    var onOpenAddItem: () -> Void
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: Date()).uppercased()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            
            // ── En-tête Principal ─────────────────────────────
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(formattedDate)
                        .font(.system(size: 11, weight: .bold))
                        .tracking(2.0)
                        .foregroundStyle(themeManager.mutedColor)
                    
                    Text("Bonjour Camille,")
                        .font(.custom("Georgia", size: 36))
                        .fontWeight(.medium)
                        .foregroundStyle(themeManager.inkColor)
                    
                    Text("Votre garde-robe a de belles idées pour aujourd’hui.")
                        .font(.system(size: 14))
                        .foregroundStyle(themeManager.mutedColor)
                }
                
                Spacer(minLength: 12)
                
                // Actions (Recherche, Ajout, Avatar)
                HStack(spacing: 8) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            store.isSearchActive.toggle()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(themeManager.inkColor)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(themeManager.panelColor)
                                    .overlay(Circle().stroke(themeManager.borderColor, lineWidth: 1))
                            )
                    }
                    
                    Button {
                        onOpenAddItem()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                                .font(.system(size: 13, weight: .bold))
                            
                            Text("Ajouter")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundStyle(themeManager.activeTheme.isDark ? Color.black : Color.white)
                        .padding(.horizontal, 14)
                        .frame(height: 40)
                        .background(
                            Capsule()
                                .fill(themeManager.primaryColor)
                        )
                    }
                    
                    Button {
                        onOpenSettings()
                    } label: {
                        Text("CM")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color(hex: "#203128"))
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color(hex: "#D9C2A6"))
                            )
                    }
                }
            }
            
            // ── Barre de Recherche Déroulante ──────────────────
            if store.isSearchActive {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundStyle(themeManager.mutedColor)
                    
                    TextField("Rechercher dans ma garde-robe...", text: $store.searchText)
                        .font(.system(size: 14))
                        .foregroundStyle(themeManager.inkColor)
                    
                    if !store.searchText.isEmpty {
                        Button {
                            store.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(themeManager.mutedColor)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(themeManager.panelColor)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(themeManager.borderColor, lineWidth: 1))
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // ── Bandeau Météo & Statistiques ───────────────────
            statsRowView
        }
    }
    
    // Grille adaptative pour la météo et les 3 stats
    private var statsRowView: some View {
        ViewThatFits(in: .horizontal) {
            // Version horizontale (iPad / Mac / écran large)
            HStack(spacing: 0) {
                weatherBlock
                dividerBlock
                statBlock(title: "PIÈCES", value: "\(store.totalPiecesCount)", subtitle: "dans votre garde-robe")
                dividerBlock
                statBlock(title: "TENUES", value: "\(store.savedOutfitsCount)", subtitle: "sauvegardées")
                dividerBlock
                statBlock(title: "CETTE SEMAINE", value: "\(store.wornThisWeekCount)", subtitle: "pièces portées", isAccent: true)
            }
            .background(
                RoundedRectangle(cornerRadius: themeManager.cardRadius)
                    .fill(themeManager.panelColor)
                    .overlay(RoundedRectangle(cornerRadius: themeManager.cardRadius).stroke(themeManager.borderColor, lineWidth: 1))
            )
            .clipShape(RoundedRectangle(cornerRadius: themeManager.cardRadius))
            
            // Version mobile (2 colonnes)
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    weatherBlock
                        .frame(maxWidth: .infinity)
                }
                
                Divider().overlay(themeManager.borderColor)
                
                HStack(spacing: 0) {
                    statBlock(title: "PIÈCES", value: "\(store.totalPiecesCount)", subtitle: "dans votre garde-robe")
                        .frame(maxWidth: .infinity)
                    
                    dividerBlock
                    
                    statBlock(title: "TENUES", value: "\(store.savedOutfitsCount)", subtitle: "sauvegardées")
                        .frame(maxWidth: .infinity)
                }
                
                Divider().overlay(themeManager.borderColor)
                
                statBlock(title: "CETTE SEMAINE", value: "\(store.wornThisWeekCount)", subtitle: "pièces portées", isAccent: true)
                    .frame(maxWidth: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: themeManager.cardRadius)
                    .fill(themeManager.panelColor)
                    .overlay(RoundedRectangle(cornerRadius: themeManager.cardRadius).stroke(themeManager.borderColor, lineWidth: 1))
            )
            .clipShape(RoundedRectangle(cornerRadius: themeManager.cardRadius))
        }
    }
    
    private var weatherBlock: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#F3EAD3"))
                    .frame(width: 48, height: 48)
                
                Image(systemName: store.weather.systemIcon)
                    .font(.system(size: 24))
                    .foregroundStyle(Color(hex: "#986F2E"))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("MÉTÉO À \(store.weather.city)")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(themeManager.mutedColor)
                
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(store.weather.temperature)°")
                        .font(.custom("Georgia", size: 28))
                        .fontWeight(.medium)
                        .foregroundStyle(themeManager.inkColor)
                }
                
                Text(store.weather.conditionText)
                    .font(.system(size: 12))
                    .foregroundStyle(themeManager.mutedColor)
            }
        }
        .padding(18)
    }
    
    private func statBlock(title: String, value: String, subtitle: String, isAccent: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(1.5)
                .foregroundStyle(themeManager.mutedColor)
            
            Text(value)
                .font(.custom("Georgia", size: 30))
                .fontWeight(.medium)
                .foregroundStyle(themeManager.inkColor)
            
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundStyle(themeManager.mutedColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            isAccent ?
                (themeManager.customColors != nil ?
                 themeManager.accentColor.opacity(0.12) :
                 (themeManager.activeTheme.isDark ? Color(hex: "#342E49") : Color(hex: "#F1ECDF"))) :
                Color.clear
        )
    }
    
    private var dividerBlock: some View {
        Rectangle()
            .fill(themeManager.borderColor)
            .frame(width: 1)
    }
}
