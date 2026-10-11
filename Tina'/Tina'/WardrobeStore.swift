import SwiftUI
import Foundation

@Observable
final class WardrobeStore {
    static let shared = WardrobeStore()
    
    // MARK: - State
    var items: [ClothingItem] = []
    var outfits: [OutfitRecommendation] = []
    var currentOutfitIndex: Int = 0
    var selectedOccasion: String = "Journée décontractée"
    var weather: WeatherData = .parisDefault
    var searchText: String = ""
    var isSearchActive: Bool = false
    
    let availableOccasions = [
        "Journée décontractée",
        "Bureau",
        "Dîner",
        "Sortie"
    ]
    
    // MARK: - Initializer & Default Data
    init() {
        loadInitialData()
    }
    
    private func loadInitialData() {
        // Mock items from Figma design
        items = [
            ClothingItem(
                name: "Chemise en lin",
                category: .top,
                imageUrl: "https://images.unsplash.com/photo-1603252109303-2751441dd157?auto=format&fit=crop&w=500&q=80",
                brand: "Sézane",
                wearCount: 3
            ),
            ClothingItem(
                name: "Jean droit écru",
                category: .bottom,
                imageUrl: "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=500&q=80",
                brand: "Arket",
                wearCount: 5
            ),
            ClothingItem(
                name: "Mocassins caramel",
                category: .shoes,
                imageUrl: "https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=500&q=80",
                brand: "Bobbies",
                wearCount: 2
            ),
            ClothingItem(
                name: "Sac structuré",
                category: .accessory,
                imageUrl: "https://images.unsplash.com/photo-1559563458-527698bf5295?auto=format&fit=crop&w=500&q=80",
                brand: "Polène",
                wearCount: 4
            ),
            ClothingItem(
                name: "Veste en cuir",
                category: .outerwear,
                imageUrl: "https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=500&q=80",
                brand: "Sandro",
                wearCount: 1
            ),
            ClothingItem(
                name: "Pull en cachemire",
                category: .top,
                imageUrl: "https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=500&q=80",
                brand: "Eric Bompard",
                wearCount: 2
            ),
            ClothingItem(
                name: "Baskets rétro",
                category: .shoes,
                imageUrl: "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=500&q=80",
                brand: "Veja",
                wearCount: 6
            ),
            ClothingItem(
                name: "Trench beige",
                category: .outerwear,
                imageUrl: "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=500&q=80",
                brand: "Burberry",
                wearCount: 2
            )
        ]
        
        // Outfits matching the Figma design photos
        outfits = [
            OutfitRecommendation(
                title: "Douceur citadine",
                occasion: "Journée décontractée",
                piecesCount: 4,
                matchScore: 98,
                imageUrl: "https://images.unsplash.com/photo-1516762689617-e1cffcef479d?auto=format&fit=crop&w=700&q=85",
                isLiked: false
            ),
            OutfitRecommendation(
                title: "Minimalisme chaud",
                occasion: "Bureau",
                piecesCount: 3,
                matchScore: 95,
                imageUrl: "https://images.unsplash.com/photo-1467043237213-65f2da53396f?auto=format&fit=crop&w=700&q=85",
                isLiked: false
            ),
            OutfitRecommendation(
                title: "Équilibre naturel",
                occasion: "Dîner",
                piecesCount: 4,
                matchScore: 97,
                imageUrl: "https://images.unsplash.com/photo-1739384879592-79903b12b2a6?auto=format&fit=crop&w=700&q=85",
                isLiked: true
            )
        ]
    }
    
    // MARK: - Computed Properties
    var currentOutfit: OutfitRecommendation {
        guard !outfits.isEmpty else {
            return OutfitRecommendation(
                title: "Tenue sur-mesure",
                occasion: selectedOccasion,
                imageUrl: ""
            )
        }
        let index = abs(currentOutfitIndex) % outfits.count
        return outfits[index]
    }
    
    var filteredItems: [ClothingItem] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return items
        }
        return items.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText) ||
            item.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
            (item.brand?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var totalPiecesCount: Int {
        items.count
    }
    
    var savedOutfitsCount: Int {
        outfits.count + 9 // Présentation esthétique
    }
    
    var wornThisWeekCount: Int {
        items.filter { $0.wearCount > 0 }.count
    }
    
    // MARK: - Actions
    func generateNextOutfit() {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentOutfitIndex = (currentOutfitIndex + 1) % max(1, outfits.count)
        }
    }
    
    func toggleLikeCurrentOutfit() {
        guard !outfits.isEmpty else { return }
        let index = abs(currentOutfitIndex) % outfits.count
        outfits[index].isLiked.toggle()
    }
    
    func addItem(_ item: ClothingItem) {
        items.insert(item, at: 0)
    }
    
    func updateWeather() async {
        // Optionnel : appel API Open-Meteo pour Paris ou localisation
        do {
            guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=48.8566&longitude=2.3522&current_weather=true") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let current = json["current_weather"] as? [String: Any],
               let temp = current["temperature"] as? Double {
                await MainActor.run {
                    self.weather = WeatherData(
                        city: "PARIS",
                        temperature: Int(round(temp)),
                        conditionText: "Doux et ensoleillé",
                        systemIcon: "sun.max.fill"
                    )
                }
            }
        } catch {
            // Utilise la météo par défaut si hors-ligne
        }
    }
}
