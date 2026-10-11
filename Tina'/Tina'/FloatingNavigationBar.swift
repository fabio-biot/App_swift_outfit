import SwiftUI

enum TinaTab: String, CaseIterable, Identifiable {
    case home = "Accueil"
    case wardrobe = "Ma garde-robe"
    case generator = "Générateur"
    case calendar = "Calendrier"
    case favorites = "Favoris"
    
    var id: String { rawValue }
    
    var systemIcon: String {
        switch self {
        case .home:      return "house.fill"
        case .wardrobe:  return "tshirt.fill"
        case .generator: return "sparkles"
        case .calendar:  return "calendar"
        case .favorites: return "heart.fill"
        }
    }
}

struct FloatingNavigationBar: View {
    @Binding var selectedTab: TinaTab
    @Bindable var themeManager = TinaThemeManager.shared
    
    var onOpenSettings: () -> Void
    var onOpenProfile: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TinaTab.allCases) { tab in
                let isSelected = selectedTab == tab
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.systemIcon)
                            .font(.system(size: isSelected ? 20 : 18, weight: isSelected ? .semibold : .regular))
                            .foregroundStyle(
                                isSelected ?
                                Color.white :
                                Color.white.opacity(0.55)
                            )
                            .scaleEffect(isSelected ? 1.08 : 1.0)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                            .foregroundStyle(
                                isSelected ?
                                Color.white :
                                Color.white.opacity(0.55)
                            )
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? Color.white.opacity(0.12) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            barBackground
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.25), radius: 25, y: 10)
        .padding(.horizontal, 16)
        .padding(.bottom, 6)
    }
    
    private var barBackground: some View {
        Group {
            if themeManager.activeTheme == .editorial {
                Color(hex: "#111111")
            } else if themeManager.activeTheme == .solaire {
                Color(hex: "#843D2C").opacity(0.95)
            } else if themeManager.activeTheme == .cobalt {
                Color(hex: "#15369A").opacity(0.95)
            } else if themeManager.activeTheme == .nocturne {
                Color(hex: "#29243A").opacity(0.95)
            } else {
                Color(hex: "#203128").opacity(0.94)
            }
        }
    }
}
