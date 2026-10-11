import SwiftUI

struct SettingsPanelSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var themeManager = TinaThemeManager.shared

    @State private var primaryColor: Color = .black
    @State private var accentColor: Color = .black
    @State private var canvasColor: Color = .white

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    
                    // ── En-tête de section ──────────────────────────
                    VStack(alignment: .leading, spacing: 6) {
                        Text("APPARENCE")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(2.0)
                            .foregroundStyle(themeManager.mutedColor)

                        Text("Personnalisez votre espace")
                            .font(.custom("Georgia", size: 28))
                            .fontWeight(.medium)
                            .foregroundStyle(themeManager.inkColor)
                    }
                    .padding(.top, 10)

                    Divider()
                        .overlay(themeManager.borderColor)

                    // ── 1. Design de l'application (5 Thèmes) ───────
                    VStack(alignment: .leading, spacing: 14) {
                        Text("DESIGN DE L’APPLICATION")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(2.0)
                            .foregroundStyle(themeManager.mutedColor)

                        VStack(spacing: 8) {
                            ForEach(TinaThemeId.allCases) { theme in
                                let isSelected = themeManager.activeTheme == theme && themeManager.customColors == nil

                                Button {
                                    themeManager.selectTheme(theme)
                                    syncColorsFromCurrentTheme()
                                } label: {
                                    HStack(spacing: 12) {
                                        Text(theme.number)
                                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                                            .foregroundStyle(themeManager.mutedColor)
                                            .frame(width: 24, alignment: .leading)

                                        Circle()
                                            .fill(Color(hex: theme.primaryHex))
                                            .frame(width: 12, height: 12)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(theme.name)
                                                .font(.custom("Georgia", size: 16))
                                                .fontWeight(.medium)
                                                .foregroundStyle(themeManager.inkColor)

                                            Text(theme.label)
                                                .font(.system(size: 12))
                                                .foregroundStyle(themeManager.mutedColor)
                                        }

                                        Spacer()

                                        if isSelected {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundStyle(themeManager.accentColor)
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: themeManager.cardRadius)
                                            .fill(isSelected ? themeManager.softColor : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: themeManager.cardRadius)
                                                    .stroke(isSelected ? themeManager.borderColor : Color.clear, lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Divider()
                        .overlay(themeManager.borderColor)

                    // ── 2. Votre Palette Sur-mesure ─────────────────
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("VOTRE PALETTE")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2.0)
                                .foregroundStyle(themeManager.mutedColor)

                            Spacer()

                            Button("Réinitialiser") {
                                themeManager.resetCustomPalette()
                                syncColorsFromCurrentTheme()
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(themeManager.accentColor)
                            .underline()
                        }

                        VStack(spacing: 10) {
                            colorRow(label: "Couleur principale", color: $primaryColor) {
                                updateCustomColors()
                            }
                            colorRow(label: "Couleur d’accent", color: $accentColor) {
                                updateCustomColors()
                            }
                            colorRow(label: "Arrière-plan", color: $canvasColor) {
                                updateCustomColors()
                            }
                        }
                    }

                    // ── Bouton Sauvegarder ──────────────────────────
                    Button {
                        dismiss()
                    } label: {
                        Text("Enregistrer mes préférences")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(themeManager.activeTheme.isDark ? Color.black : Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: themeManager.buttonRadius)
                                    .fill(themeManager.primaryColor)
                            )
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
            .background(themeManager.panelColor.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(themeManager.inkColor)
                            .padding(8)
                            .background(Circle().fill(themeManager.borderColor.opacity(0.3)))
                    }
                }
            }
        }
        .onAppear {
            syncColorsFromCurrentTheme()
        }
    }

    private func colorRow(label: String, color: Binding<Color>, onChange: @escaping () -> Void) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(themeManager.inkColor)

            Spacer()

            HStack(spacing: 8) {
                ColorPicker("", selection: color, supportsOpacity: false)
                    .labelsHidden()
                    .onChange(of: color.wrappedValue) { _, _ in
                        onChange()
                    }

                Text(color.wrappedValue.toHex())
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(themeManager.mutedColor)
                    .frame(width: 65, alignment: .trailing)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(themeManager.canvasColor)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(themeManager.borderColor, lineWidth: 1))
        )
    }

    private func syncColorsFromCurrentTheme() {
        primaryColor = themeManager.primaryColor
        accentColor = themeManager.accentColor
        canvasColor = themeManager.canvasColor
    }

    private func updateCustomColors() {
        themeManager.customColors = CustomPalette(
            primary: primaryColor.toHex(),
            accent: accentColor.toHex(),
            canvas: canvasColor.toHex()
        )
    }
}
