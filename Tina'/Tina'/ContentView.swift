import SwiftUI

struct ContentView: View {
    @Bindable var store = WardrobeStore.shared
    @Bindable var themeManager = TinaThemeManager.shared
    
    @State private var selectedTab: TinaTab = .home
    @State private var showingSettings = false
    @State private var showingAddItem = false
    @State private var showingFullWardrobe = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // ── Arrière-plan Canvas du Thème ───────────────────────
            themeManager.canvasColor
                .ignoresSafeArea()
            
            // Halo lumineux radial pour le mode sombre Nocturne
            if themeManager.activeTheme == .nocturne {
                RadialGradient(
                    gradient: Gradient(colors: [Color(hex: "#6F55CB").opacity(0.2), Color.clear]),
                    center: .topTrailing,
                    startRadius: 50,
                    endRadius: 450
                )
                .ignoresSafeArea()
            }
            
            // ── Contenu Principal Déroulant ───────────────────────
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // 1. En-tête + Barre de recherche + Météo & Stats
                    HeaderAndStatsView(
                        onOpenSettings: { showingSettings = true },
                        onOpenAddItem: { showingAddItem = true }
                    )
                    .padding(.top, 16)
                    
                    // 2. Section Générateur d'Outfits
                    OutfitGeneratorView()
                    
                    // 3. Section Garde-Robe Récemment Ajoutées
                    RecentWardrobeView(
                        onSeeAll: { showingFullWardrobe = true }
                    )
                    
                    // Espace supplémentaire pour la barre flottante inférieure
                    Spacer(minLength: 110)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: 1100) // Centrage esthétique sur iPad / Mac
            }
            
            // ── Barre de Navigation Flottante ─────────────────────
            FloatingNavigationBar(
                selectedTab: $selectedTab,
                onOpenSettings: { showingSettings = true },
                onOpenProfile: { showingSettings = true }
            )
            .onChange(of: selectedTab) { _, newTab in
                handleTabSelection(newTab)
            }
        }
        // Modales
        .sheet(isPresented: $showingSettings) {
            SettingsPanelSheet()
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView { newItem in
                store.addItem(newItem)
            }
        }
        .sheet(isPresented: $showingFullWardrobe) {
            FullWardrobeSheet()
        }
        .task {
            await store.updateWeather()
        }
    }
    
    private func handleTabSelection(_ tab: TinaTab) {
        switch tab {
        case .home:
            break
        case .wardrobe:
            showingFullWardrobe = true
            selectedTab = .home
        case .generator:
            store.generateNextOutfit()
            selectedTab = .home
        case .calendar:
            // Placeholder interactif
            selectedTab = .home
        case .favorites:
            showingFullWardrobe = true
            selectedTab = .home
        }
    }
}

#Preview {
    ContentView()
}
