import Foundation

// MARK: - Catégories
enum Category: String, CaseIterable, Codable {
    case top = "Hauts"
    case bottom = "Bas"
    case shoes = "Chaussures"
    case accessory = "Accessoires"
    case outerwear = "Vestes"
    
    var icon: String {
        switch self {
        case .top: return "tshirt"
        case .bottom: return "figure.walk"
        case .shoes: return "shoe.2"
        case .accessory: return "handbag"
        case .outerwear: return "jacket"
        }
    }
}

// MARK: - Modèle Vêtement
struct ClothingItem: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: Category
    var imageName: String?
    var imageUrl: String?
    var brand: String?
    var colorName: String?
    var wearCount: Int
    var isFavorite: Bool
    var dateAdded: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        category: Category,
        imageName: String? = nil,
        imageUrl: String? = nil,
        brand: String? = nil,
        colorName: String? = nil,
        wearCount: Int = 0,
        isFavorite: Bool = false,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.brand = brand
        self.colorName = colorName
        self.wearCount = wearCount
        self.isFavorite = isFavorite
        self.dateAdded = dateAdded
    }
}

// MARK: - Modèle Tenue Recommandée
struct OutfitRecommendation: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var occasion: String
    var piecesCount: Int
    var matchScore: Int
    var imageUrl: String
    var isLiked: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        occasion: String,
        piecesCount: Int = 4,
        matchScore: Int = 98,
        imageUrl: String,
        isLiked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.occasion = occasion
        self.piecesCount = piecesCount
        self.matchScore = matchScore
        self.imageUrl = imageUrl
        self.isLiked = isLiked
    }
}

// MARK: - Modèle Météo
struct WeatherData: Codable, Equatable {
    var city: String
    var temperature: Int
    var conditionText: String
    var systemIcon: String
    
    static let parisDefault = WeatherData(
        city: "PARIS",
        temperature: 18,
        conditionText: "Doux et ensoleillé",
        systemIcon: "sun.max.fill"
    )
}
