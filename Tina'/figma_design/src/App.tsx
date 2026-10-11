import { useState } from "react";

type IconName =
  | "home"
  | "hanger"
  | "sparkles"
  | "calendar"
  | "heart"
  | "settings"
  | "plus"
  | "search"
  | "sun"
  | "chevron"
  | "refresh";

function Icon({ name, size = 20 }: { name: IconName; size?: number }) {
  const paths: Record<IconName, React.ReactNode> = {
    home: <><path d="m3 11 9-8 9 8"/><path d="M5 10v10h14V10M9 20v-6h6v6"/></>,
    hanger: <><path d="M12 7a2 2 0 1 0-2-2"/><path d="m12 7-9 9h18Z"/></>,
    sparkles: <><path d="m12 3 1.2 3.8L17 8l-3.8 1.2L12 13l-1.2-3.8L7 8l3.8-1.2Z"/><path d="m5 14 .8 2.2L8 17l-2.2.8L5 20l-.8-2.2L2 17l2.2-.8Z"/><path d="m19 14 .5 1.5L21 16l-1.5.5L19 18l-.5-1.5L17 16l1.5-.5Z"/></>,
    calendar: <><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M16 3v4M8 3v4M3 10h18"/></>,
    heart: <path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1.1-1.1a5.5 5.5 0 0 0-7.8 7.8l1.1 1.1L12 21l7.7-7.5 1.1-1.1a5.5 5.5 0 0 0 0-7.8Z"/>,
    settings: <><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1-2.8 2.8-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.6v.2h-4V21a1.7 1.7 0 0 0-1-1.6 1.7 1.7 0 0 0-1.9.3l-.1.1L4.2 17l.1-.1a1.7 1.7 0 0 0 .3-1.9A1.7 1.7 0 0 0 3 14H2.8v-4H3a1.7 1.7 0 0 0 1.6-1 1.7 1.7 0 0 0-.3-1.9L4.2 7 7 4.2l.1.1a1.7 1.7 0 0 0 1.9.3A1.7 1.7 0 0 0 10 3v-.2h4V3a1.7 1.7 0 0 0 1 1.6 1.7 1.7 0 0 0 1.9-.3l.1-.1L19.8 7l-.1.1a1.7 1.7 0 0 0-.3 1.9 1.7 1.7 0 0 0 1.6 1h.2v4H21a1.7 1.7 0 0 0-1.6 1Z"/></>,
    plus: <path d="M12 5v14M5 12h14"/>,
    search: <><circle cx="11" cy="11" r="7"/><path d="m20 20-4-4"/></>,
    sun: <><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></>,
    chevron: <path d="m9 18 6-6-6-6"/>,
    refresh: <><path d="M20 7v5h-5"/><path d="M4 17v-5h5"/><path d="M6.1 8a7 7 0 0 1 11.5-2.6L20 8M4 16l2.4 2.6A7 7 0 0 0 18 16"/></>,
  };
  return <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}

const photos = [
  "https://images.unsplash.com/photo-1516762689617-e1cffcef479d?auto=format&fit=crop&w=700&q=85",
  "https://images.unsplash.com/photo-1467043237213-65f2da53396f?auto=format&fit=crop&w=700&q=85",
  "https://images.unsplash.com/photo-1739384879592-79903b12b2a6?auto=format&fit=crop&w=700&q=85",
];

const nav: { label: string; icon: IconName }[] = [
  { label: "Accueil", icon: "home" },
  { label: "Ma garde-robe", icon: "hanger" },
  { label: "Générateur", icon: "sparkles" },
  { label: "Calendrier", icon: "calendar" },
  { label: "Favoris", icon: "heart" },
];

const themes = [
  { id: "botanique", name: "ÉTIOLE", label: "Vestiaire intelligent", title: "Une tenue, rien que pour vous.", description: "Votre dressing quotidien, calme et naturel. Composez des tenues avec les pièces que vous possédez déjà.", action: "Générer ma tenue", color: "#31483b", accent: "#b56949", canvas: "#f6f5f0" },
  { id: "editorial", name: "CAPSULE", label: "Moins, mais mieux", title: "Votre capsule. Sans hésiter.", description: "Une approche éditoriale qui privilégie les essentiels, la répétition intelligente et les associations intemporelles.", action: "Composer ma capsule", color: "#171717", accent: "#171717", canvas: "#f7f7f5" },
  { id: "solaire", name: "SOLÉA", label: "Le style selon l’humeur", title: "Habillez votre énergie.", description: "Une expérience chaleureuse qui imagine votre look selon votre humeur, la météo et votre programme.", action: "Créer mon look", color: "#c85e36", accent: "#b44627", canvas: "#f7eddb" },
  { id: "cobalt", name: "LOOKLAB", label: "Planificateur de looks", title: "Planifiez. Portez. Recommencez.", description: "Un outil précis pour organiser vos tenues, suivre l’usage de chaque pièce et préparer votre semaine.", action: "Planifier ma tenue", color: "#2855d9", accent: "#2855d9", canvas: "#f2f5ff" },
  { id: "nocturne", name: "MUSE", label: "Styliste personnel IA", title: "Votre styliste vous connaît.", description: "Une expérience premium qui apprend vos goûts et propose des silhouettes adaptées à chaque moment.", action: "Demander à Muse", color: "#9a82ff", accent: "#9a82ff", canvas: "#16141d" },
] as const;

export default function App() {
  const [active, setActive] = useState("Accueil");
  const [occasion, setOccasion] = useState("Journée décontractée");
  const [outfit, setOutfit] = useState(0);
  const [liked, setLiked] = useState(false);
  const [searching, setSearching] = useState(false);
  const [theme, setTheme] = useState<(typeof themes)[number]["id"]>("botanique");
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [customColors, setCustomColors] = useState<{ primary: string; accent: string; canvas: string } | null>(null);
  const concept = themes.find((item) => item.id === theme) ?? themes[0];
  const colors = customColors ?? { primary: concept.color, accent: concept.accent, canvas: concept.canvas };

  const generate = () => {
    setOutfit((value) => (value + 1) % photos.length);
    setLiked(false);
  };

  return (
    <div
      className={`app-shell ${customColors ? "custom-colors" : ""}`}
      data-theme={theme}
      style={customColors ? {
        "--custom-primary": customColors.primary,
        "--custom-accent": customColors.accent,
        "--custom-canvas": customColors.canvas,
      } as React.CSSProperties : undefined}
    >
      <aside className="sidebar">
        <div className="brand"><span className="brand-mark"><Icon name="hanger" size={18}/></span><span>{concept.name}</span></div>
        <nav className="nav-list" aria-label="Navigation principale">
          {nav.map((item) => (
            <button key={item.label} className={`nav-item ${active === item.label ? "active" : ""}`} onClick={() => setActive(item.label)}>
              <Icon name={item.icon}/><span>{item.label}</span>
            </button>
          ))}
        </nav>
        <div className="sidebar-bottom">
          <button className="nav-item" onClick={() => setSettingsOpen(true)}><Icon name="settings"/><span>Paramètres</span></button>
          <div className="profile">
            <div className="avatar">CM</div>
            <div><strong>Camille Moreau</strong><span>48 pièces</span></div>
            <Icon name="chevron" size={16}/>
          </div>
        </div>
      </aside>

      <main>
        <header>
          <div>
            <span className="eyebrow">MARDI 14 MAI</span>
            <h1>Bonjour Camille,</h1>
            <p>Votre garde-robe a de belles idées pour aujourd’hui.</p>
          </div>
          <div className="header-actions">
            <button className="icon-button" aria-label="Rechercher" onClick={() => setSearching(!searching)}><Icon name="search"/></button>
            <button className="add-button"><Icon name="plus" size={18}/> Ajouter une pièce</button>
            <button className="header-avatar" aria-label="Ouvrir les paramètres" onClick={() => setSettingsOpen(true)}>CM</button>
          </div>
        </header>

        {searching && <div className="search-bar"><Icon name="search"/><input autoFocus placeholder="Rechercher dans ma garde-robe..." /></div>}

        <section className="stats-row">
          <div className="weather-card">
            <div className="weather-icon"><Icon name="sun" size={26}/></div>
            <div><span>MÉTÉO À PARIS</span><strong>18°</strong><p>Doux et ensoleillé</p></div>
          </div>
          <div className="mini-stat"><span>PIÈCES</span><strong>48</strong><p>dans votre garde-robe</p></div>
          <div className="mini-stat"><span>TENUES</span><strong>12</strong><p>sauvegardées</p></div>
          <div className="mini-stat accent-stat"><span>CETTE SEMAINE</span><strong>7</strong><p>pièces portées</p></div>
        </section>

        <section className="generator">
          <div className="generator-copy">
            <span className="section-kicker"><Icon name="sparkles" size={15}/> {concept.label.toUpperCase()}</span>
            <h2>{concept.title}</h2>
            <p>{concept.description}</p>
            <label>Quelle est l’occasion ?</label>
            <div className="occasion-grid">
              {["Journée décontractée", "Bureau", "Dîner", "Sortie"].map((item) => (
                <button key={item} className={occasion === item ? "selected" : ""} onClick={() => setOccasion(item)}>{item}</button>
              ))}
            </div>
            <button className="generate-button" onClick={generate}><Icon name="sparkles" size={18}/> {concept.action}</button>
          </div>

          <div className="outfit-card">
            <div className="outfit-image-wrap">
              <img key={photos[outfit]} src={photos[outfit]} alt="Sélection de vêtements composant la tenue du jour" />
              <span className="match-badge">98% match</span>
              <button className={`heart-button ${liked ? "liked" : ""}`} aria-label="Ajouter aux favoris" onClick={() => setLiked(!liked)}><Icon name="heart"/></button>
            </div>
            <div className="outfit-info">
              <div><span>VOTRE TENUE</span><h3>{["Douceur citadine", "Minimalisme chaud", "Équilibre naturel"][outfit]}</h3><p>{occasion} · 4 pièces</p></div>
              <button className="refresh-button" aria-label="Nouvelle suggestion" onClick={generate}><Icon name="refresh" size={18}/></button>
            </div>
          </div>
        </section>

        <section className="recent-section">
          <div className="section-heading"><div><span className="eyebrow">VOTRE STYLE</span><h2>Récemment ajoutées</h2></div><button>Voir toute la garde-robe <Icon name="chevron" size={16}/></button></div>
          <div className="clothes-grid">
            {[
              ["Chemise en lin", "Hauts", "https://images.unsplash.com/photo-1603252109303-2751441dd157?auto=format&fit=crop&w=500&q=80"],
              ["Jean droit écru", "Bas", "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=500&q=80"],
              ["Mocassins caramel", "Chaussures", "https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=500&q=80"],
              ["Sac structuré", "Accessoires", "https://images.unsplash.com/photo-1559563458-527698bf5295?auto=format&fit=crop&w=500&q=80"],
            ].map(([name, category, image]) => (
              <article className="clothing-card" key={name}><img src={image} alt={name}/><div><span>{category}</span><h3>{name}</h3></div></article>
            ))}
          </div>
        </section>
      </main>

      {settingsOpen && (
        <div className="settings-layer" role="dialog" aria-modal="true" aria-label="Paramètres d’apparence">
          <button className="settings-backdrop" aria-label="Fermer" onClick={() => setSettingsOpen(false)}/>
          <aside className="settings-panel">
            <div className="settings-heading">
              <div><span>APPARENCE</span><h2>Personnalisez votre espace</h2></div>
              <button className="close-button" onClick={() => setSettingsOpen(false)} aria-label="Fermer">×</button>
            </div>

            <div className="settings-section">
              <span className="settings-label">DESIGN DE L’APPLICATION</span>
              <div className="app-choice-list">
                {themes.map((item, index) => (
                  <button
                    key={item.id}
                    className={theme === item.id ? "active" : ""}
                    onClick={() => { setTheme(item.id); setCustomColors(null); }}
                  >
                    <span className="choice-number">0{index + 1}</span>
                    <i className={`theme-dot theme-dot-${item.id}`}/>
                    <div><strong>{item.name}</strong><span>{item.label}</span></div>
                    <span className="choice-check">{theme === item.id ? "✓" : ""}</span>
                  </button>
                ))}
              </div>
            </div>

            <div className="settings-section">
              <div className="palette-title">
                <span className="settings-label">VOTRE PALETTE</span>
                <button onClick={() => setCustomColors(null)}>Réinitialiser</button>
              </div>
              <div className="color-controls">
                {([
                  ["primary", "Couleur principale"],
                  ["accent", "Couleur d’accent"],
                  ["canvas", "Arrière-plan"],
                ] as const).map(([key, label]) => (
                  <label key={key}>
                    <span>{label}</span>
                    <div>
                      <input
                        type="color"
                        value={colors[key]}
                        onChange={(event) => setCustomColors({ ...colors, [key]: event.target.value })}
                      />
                      <code>{colors[key].toUpperCase()}</code>
                    </div>
                  </label>
                ))}
              </div>
            </div>

            <button className="save-settings" onClick={() => setSettingsOpen(false)}>Enregistrer mes préférences</button>
          </aside>
        </div>
      )}
    </div>
  );
}
