# CONTEXT.md - Projet Tina 👗

## 🌟 Vision du Projet
**Tina** est une application iOS conçue pour être l'assistant personnel ultime de votre garde-robe. Plus qu'un simple catalogue numérique, l'application vise à simplifier la gestion quotidienne des tenues en utilisant des algorithmes de recommandation intelligents basés sur la météo, l'occasion et l'harmonie des couleurs.

---

## 🚀 Fonctionnalités Clés (à date)

### 1. Gestion de la Garde-robe (Wardrobe)
- **Inventaire Complet** : Ajout de vêtements avec nom, marque, catégorie, et plusieurs couleurs (primaire, secondaire, tertiaire).
- **Prise de Photo** : Intégration de la caméra et de la galerie pour immortaliser chaque pièce.
- **Organisation par Tags** : Système de tags flexible (Saison, Occasion, Style) pour filtrer et organiser les vêtements.
- **Filtres Avancés** : Recherche par texte, filtrage par catégorie, couleur, tags ou favoris.

### 2. Générateur d'Outfits Intelligent
- **Algorithme d'Harmonie** : Crée automatiquement des tenues basées sur des règles de colorimétrie (neutres, monochromes, paires définies).
- **Priorisation Contextuelle** : Les suggestions s'adaptent à l'occasion choisie (Sport, Soirée, Travail, etc.).
- **Score de Tenue** : Chaque tenue générée reçoit un score basé sur les préférences de l'utilisateur (marques et couleurs préférées).

### 3. Intégration Météo
- **Consultation Locale** : Utilisation de l'API Open-Meteo pour obtenir la température et les conditions actuelles via la localisation de l'appareil.
- **Adaptation Automatique** : Le générateur peut suggérer des couches supplémentaires (vestes, accessoires) si la température est basse.

### 4. Planification et Voyage
- **Planificateur (Planner)** : Calendrier permettant de prévoir ses tenues pour les jours à venir.
- **Gestion de Voyages (Trips)** : Création de listes de tenues spécifiques pour des déplacements, facilitant la préparation des valises.
- **Collections** : Possibilité de regrouper des pièces ou des tenues par thématiques personnalisées.

### 5. Personnalisation et Statistiques
- **Profil Utilisateur** : Définition des marques et couleurs favorites pour influencer l'algorithme.
- **Statistiques** : Insights sur le contenu de la garde-robe et l'utilisation des vêtements.
- **Thèmes** : Support complet du Mode Sombre et thèmes personnalisables.

---

## 🛠 Architecture Technique

L'application est structurée de manière modulaire en utilisant **Swift Package Manager (SPM)** pour séparer les responsabilités :

### **Tina Kit** (Module Principal)
- **TinaModels** : Définition des structures de données (`ClothingItem`, `Outfit`, `Trip`, `Collection`).
- **TinaServices** : Logique métier transverse (`WeatherManager`, `TagsManager`, `ImageStore`, `HapticManager`).
- **TinaUI** : Composants graphiques réutilisables (`ClothingItemRow`, `OutfitCard`).

### **Application Tina** (Projet Principal)
- **Vues** : `WardrobeView`, `GeneratorView`, `PlannerView`, `TripsListView`, `StatisticsView`.
- **Stores** : Gestion de l'état global et de la persistance via `EnvironmentObject` (`WardrobeStore`, `OutfitStore`, etc.).

---

## 🎯 Raisons du Développement
1. **Gain de Temps** : Éviter le dilemme du "qu'est-ce que je mets ce matin ?" grâce aux suggestions automatiques.
2. **Optimisation de la Garde-robe** : Redécouvrir des pièces peu portées et maximiser les combinaisons possibles.
3. **Assistance au Voyage** : Simplifier la logistique des déplacements en planifiant les tenues à l'avance.
4. **Expérience iOS Premium** : Offrir une interface moderne, fluide (Haptics) et sécurisée (stockage local).

---

## 📈 Évolutions Futures (Pistes)
- IA pour le détourage automatique des photos (Vision API).
- Calcul du "Coût par Port" (Cost per Wear).
- Partage social de tenues.
- Migration vers SwiftData pour une meilleure performance à grande échelle.
