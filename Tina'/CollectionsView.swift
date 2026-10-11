import SwiftUI
import SwiftData

struct CollectionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query(sort: \ClothingCollection.dateCreated, order: .reverse)
    private var collections: [ClothingCollection]
    
    @State private var showingNameDetails = false
    @State private var showingPicker = false
    @State private var setupName: String = ""
    @State private var setupDesc: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.tinaBackground()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: TinaSpacing.xs) {
                        Text("Collections")
                            .font(TinaFont.pageTitle)
                            .foregroundStyle(TinaColor.primary)
                        Text("Organize your wardrobe your way")
                            .font(TinaFont.bodyText)
                            .foregroundStyle(TinaColor.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, TinaSpacing.xl)
                    .padding(.top, TinaSpacing.xxl)
                    
                    // Collections list
                    if collections.isEmpty {
                        EmptyStateView(action: { showingNameDetails = true }, actionLabel: "Create your first collection")
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: TinaSpacing.md),
                                GridItem(.flexible(), spacing: TinaSpacing.md)
                            ], spacing: TinaSpacing.md) {
                                ForEach(collections) { collection in
                                    NavigationLink(destination: CollectionDetailView(collection: collection)) {
                                        CollectionCardView(collection: collection)
                                    }
                                }
                            }
                            .padding(.horizontal, TinaSpacing.xl)
                            .padding(.top, TinaSpacing.lg)
                            .padding(.bottom, 100) // space for FAB
                        }
                    }
                }
                
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showingNameDetails = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.white)
                                .background(Circle().fill(TinaColor.black))
                                .tinaShadow(radius: 20, y: 8)
                        }
                        .frame(width: 56, height: 56)
                        .padding(.trailing, TinaSpacing.xl)
                        .padding(.bottom, TinaSpacing.lg)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // optional: maybe settings
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 22))
                            .foregroundStyle(TinaColor.tertiary)
                    }
                }
            }
            .sheet(isPresented: $showingNameDetails) {
                NewCollectionSetupView { name, desc in
                    setupName = name
                    setupDesc = desc
                    showingNameDetails = false
                    showingPicker = true
                }
            }
            .sheet(isPresented: $showingPicker) {
                ClothingPickerView { selectedItems in
                    let newCollection = ClothingCollection(name: setupName, desc: setupDesc, items: selectedItems)
                    modelContext.insert(newCollection)
                    try? modelContext.save()
                    showingPicker = false
                    // reset
                    setupName = ""
                    setupDesc = ""
                }
            }
        }
    }
}

// Empty state component
private struct EmptyStateView: View {
    let action: () -> Void
    let actionLabel: String
    
    var body: some View {
        VStack(spacing: TinaSpacing.lg) {
            Image(systemName: "folder")
                .font(.system(size: 56))
                .foregroundStyle(TinaColor.tertiary.opacity(0.7))
            Text("Your wardrobe, organized.")
                .font(TinaFont.sectionTitle)
                .foregroundStyle(TinaColor.primary)
            Text("Create collections for trips, seasons, occasions and your favorite styles.")
                .font(TinaFont.bodyText)
                .foregroundStyle(TinaColor.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            Button(action: action) {
                Text(actionLabel)
                    .font(TinaFont.body(16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: 240)
                    .padding(.vertical, TinaSpacing.md)
                    .background(
                        Capsule()
                            .fill(TinaColor.black)
                    )
            }
        }
        .padding(.horizontal, TinaSpacing.xxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Placeholder for collection card view
struct CollectionCardView: View {
    let collection: ClothingCollection
    var body: some View {
        VStack(alignment: .leading, spacing: TinaSpacing.sm) {
            // Preview area
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(TinaColor.cardSubtle)
                    .frame(height: 80)
                    .overlay(
                        // TODO: actual preview of items
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 24))
                                .foregroundStyle(TinaColor.tertiary)
                            Text("Preview")
                                .font(TinaFont.caption2)
                                .foregroundStyle(TinaColor.secondary)
                        }
                    )
                    .cornerRadius(TinaRadius.md)
                
                // Item count badge
                ZStack {
                    Circle()
                        .fill(TinaColor.gold)
                        .frame(width: 24, height: 24)
                    Text("\(collection.items.count)")
                        .font(TinaFont.caption2.bold())
                    .foregroundStyle(.white)
                }
                .offset(x: 8, y: -8)
            }
            
            Text(collection.name)
                .font(TinaFont.cardTitle)
                .foregroundStyle(TinaColor.primary)
            if !collection.desc.isEmpty {
                Text(collection.desc)
                    .font(TinaFont.caption2)
                    .foregroundStyle(TinaColor.tertiary)
                    .lineLimit(2)
            }
            Text("\(collection.items.count) items")
                .font(TinaFont.caption2)
                .foregroundStyle(TinaColor.secondary)
        }
        .padding(TinaSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: TinaRadius.lg)
                .fill(TinaColor.card)
                .tinaShadow()
        )
    }
}

// Placeholder for new collection setup
private struct NewCollectionSetupView: View {
    let onContinue: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var desc: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nom de la collection")
                            .font(TinaFont.sectionTitle)) {
                    TextField("Summer 2026, Workwear, etc.", text: $name)
                        .font(TinaFont.bodyText)
                }
                Section(header: Text("Description (optionnelle)")
                            .font(TinaFont.sectionTitle)) {
                    TextField("Une courte description...", text: $desc)
                        .font(TinaFont.bodyText)
                }
            }
            .navigationTitle("Nouvelle collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                        .foregroundStyle(TinaColor.tertiary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Continuer") {
                        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        onContinue(name, desc)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .font(TinaFont.body(16, weight: .semibold))
                }
            }
        }
    }
}
