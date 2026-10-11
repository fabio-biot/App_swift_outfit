import SwiftUI

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

// MARK: - 5 Visual Directions (Thèmes Figma)
enum TinaThemeId: String, CaseIterable, Identifiable, Codable {
    case botanique = "botanique"
    case editorial = "editorial"
    case solaire = "solaire"
    case cobalt = "cobalt"
    case nocturne = "nocturne"

    var id: String { rawValue }

    var number: String {
        switch self {
        case .botanique: return "01"
        case .editorial: return "02"
        case .solaire:   return "03"
        case .cobalt:    return "04"
        case .nocturne:  return "05"
        }
    }

    var name: String {
        switch self {
        case .botanique: return "ÉTIOLE"
        case .editorial: return "CAPSULE"
        case .solaire:   return "SOLÉA"
        case .cobalt:    return "LOOKLAB"
        case .nocturne:  return "MUSE"
        }
    }

    var label: String {
        switch self {
        case .botanique: return "Vestiaire intelligent"
        case .editorial: return "Moins, mais mieux"
        case .solaire:   return "Le style selon l’humeur"
        case .cobalt:    return "Planificateur de looks"
        case .nocturne:  return "Styliste personnel IA"
        }
    }

    var title: String {
        switch self {
        case .botanique: return "Une tenue, rien que pour vous."
        case .editorial: return "Votre capsule. Sans hésiter."
        case .solaire:   return "Habillez votre énergie."
        case .cobalt:    return "Planifiez. Portez. Recommencez."
        case .nocturne:  return "Votre styliste vous connaît."
        }
    }

    var themeDescription: String {
        switch self {
        case .botanique: return "Votre dressing quotidien, calme et naturel. Composez des tenues avec les pièces que vous possédez déjà."
        case .editorial: return "Une approche éditoriale qui privilégie les essentiels, la répétition intelligente et les associations intemporelles."
        case .solaire:   return "Une expérience chaleureuse qui imagine votre look selon votre humeur, la météo et votre programme."
        case .cobalt:    return "Un outil précis pour organiser vos tenues, suivre l’usage de chaque pièce et préparer votre semaine."
        case .nocturne:  return "Une expérience premium qui apprend vos goûts et propose des silhouettes adaptées à chaque moment."
        }
    }

    var action: String {
        switch self {
        case .botanique: return "Générer ma tenue"
        case .editorial: return "Composer ma capsule"
        case .solaire:   return "Créer mon look"
        case .cobalt:    return "Planifier ma tenue"
        case .nocturne:  return "Demander à Muse"
        }
    }

    // Default Hex Colors
    var primaryHex: String {
        switch self {
        case .botanique: return "#31483B"
        case .editorial: return "#111111"
        case .solaire:   return "#8D4028"
        case .cobalt:    return "#183CA9"
        case .nocturne:  return "#9A82FF"
        }
    }

    var accentHex: String {
        switch self {
        case .botanique: return "#B56949"
        case .editorial: return "#111111"
        case .solaire:   return "#C85E36"
        case .cobalt:    return "#2855D9"
        case .nocturne:  return "#9A82FF"
        }
    }

    var canvasHex: String {
        switch self {
        case .botanique: return "#F6F5F0"
        case .editorial: return "#F7F7F5"
        case .solaire:   return "#F7EDDB"
        case .cobalt:    return "#F2F5FF"
        case .nocturne:  return "#16141D"
        }
    }

    var panelHex: String {
        switch self {
        case .botanique: return "#FFFFFF"
        case .editorial: return "#FFFFFF"
        case .solaire:   return "#FFFAF0"
        case .cobalt:    return "#FFFFFF"
        case .nocturne:  return "#211E2B"
        }
    }

    var softHex: String {
        switch self {
        case .botanique: return "#E6EADB"
        case .editorial: return "#EEEEEC"
        case .solaire:   return "#F4D9AD"
        case .cobalt:    return "#DFE7FF"
        case .nocturne:  return "#302A45"
        }
    }

    var generatorBgHex: String {
        switch self {
        case .botanique: return "#E6EADB"
        case .editorial: return "#E8E8E4"
        case .solaire:   return "#F1C887"
        case .cobalt:    return "#DCE5FF"
        case .nocturne:  return "#29243A"
        }
    }

    var cardRadius: CGFloat {
        switch self {
        case .botanique: return 16
        case .editorial: return 0 // Angles vifs radicaux
        case .solaire:   return 28 // Très arrondi et doux
        case .cobalt:    return 14
        case .nocturne:  return 18
        }
    }

    var buttonRadius: CGFloat {
        switch self {
        case .botanique: return 10
        case .editorial: return 0
        case .solaire:   return 24
        case .cobalt:    return 8
        case .nocturne:  return 12
        }
    }

    var isMonochrome: Bool {
        self == .editorial
    }

    var isDark: Bool {
        self == .nocturne
    }
}

// MARK: - Custom Color Palette
struct CustomPalette: Codable, Equatable {
    var primary: String
    var accent: String
    var canvas: String
}

// MARK: - Tina Theme Manager (Observable)
@Observable
final class TinaThemeManager {
    static let shared = TinaThemeManager()

    var activeTheme: TinaThemeId {
        didSet {
            UserDefaults.standard.set(activeTheme.rawValue, forKey: "tina_selected_theme")
        }
    }

    var customColors: CustomPalette? {
        didSet {
            if let customColors {
                if let encoded = try? JSONEncoder().encode(customColors) {
                    UserDefaults.standard.set(encoded, forKey: "tina_custom_palette")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "tina_custom_palette")
            }
        }
    }

    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: "tina_selected_theme"),
           let theme = TinaThemeId(rawValue: savedTheme) {
            self.activeTheme = theme
        } else {
            self.activeTheme = .botanique
        }

        if let savedPaletteData = UserDefaults.standard.data(forKey: "tina_custom_palette"),
           let palette = try? JSONDecoder().decode(CustomPalette.self, from: savedPaletteData) {
            self.customColors = palette
        } else {
            self.customColors = nil
        }
    }

    // MARK: - Dynamic Colors
    var primaryColor: Color {
        if let customColors {
            return Color(hex: customColors.primary)
        }
        return Color(hex: activeTheme.primaryHex)
    }

    var accentColor: Color {
        if let customColors {
            return Color(hex: customColors.accent)
        }
        return Color(hex: activeTheme.accentHex)
    }

    var canvasColor: Color {
        if let customColors {
            return Color(hex: customColors.canvas)
        }
        return Color(hex: activeTheme.canvasHex)
    }

    var panelColor: Color {
        Color(hex: activeTheme.panelHex)
    }

    var softColor: Color {
        Color(hex: activeTheme.softHex)
    }

    var generatorBgColor: Color {
        if let customColors {
            return Color(hex: customColors.primary).opacity(0.15)
        }
        return Color(hex: activeTheme.generatorBgHex)
    }

    var inkColor: Color {
        if activeTheme.isDark {
            return Color(hex: "#F2EFFC")
        }
        return Color(hex: "#263229")
    }

    var mutedColor: Color {
        if activeTheme.isDark {
            return Color(hex: "#A9A3BB")
        }
        return Color(hex: "#7F897F")
    }

    var borderColor: Color {
        if activeTheme.isDark {
            return Color(hex: "#393448")
        }
        return Color(hex: "#DEDED6")
    }

    var cardRadius: CGFloat {
        activeTheme.cardRadius
    }

    var buttonRadius: CGFloat {
        activeTheme.buttonRadius
    }

    func resetCustomPalette() {
        customColors = nil
    }

    func selectTheme(_ theme: TinaThemeId) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            self.activeTheme = theme
            self.customColors = nil
        }
    }
}
