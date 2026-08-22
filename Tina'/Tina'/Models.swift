import Foundation

// 1. Enumération pour les Catégories
enum Category: String, CaseIterable, Codable {
    case top = "Haut"
    case bottom = "Bas"
    case shoes = "Chaussures"
    case accessory = "Accessoire"
    case outerwear = "Veste/Manteau"
    
    var icon: String {
        switch self {
        case .top: return "tshirt"
        case .bottom: return "figure.walk"
        case .shoes: return "shoe"
        case .accessory: return "eyeglasses"
        case .outerwear: return "jacket"
        }
    }
}

// 2. Structure pour un Vêtement
struct ClothingItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: Category
    var imageName: String?
    var dateAdded: Date
    
    init(id: UUID = UUID(), name: String, category: Category, imageName: String? = nil, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.imageName = imageName
        self.dateAdded = dateAdded
    }
}
