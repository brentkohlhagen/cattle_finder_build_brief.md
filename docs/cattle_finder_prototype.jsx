import React, { useState, useMemo } from "react";
import {
  Search,
  MapPin,
  Heart,
  PlusCircle,
  ListFilter,
  Truck,
  Link2,
  ChevronDown,
  ChevronRight,
  X,
  Check,
  Send,
  SlidersHorizontal,
  Trash2,
  BadgeCheck,
  Clock3,
} from "lucide-react";

/* ---------------------------------------------------------------
   Design tokens
   Ink / ochre / rust palette pulled from paddock + saleyard-board
   materials rather than a generic SaaS kit. Oswald for the
   condensed, sign-painted headings; Inter for UI body copy;
   IBM Plex Mono for the numbers, because weight, price and
   distance are the actual product.
---------------------------------------------------------------- */
const FONT_IMPORT =
  "@import url('https://fonts.googleapis.com/css2?family=Oswald:wght@500;600;700&family=Inter:wght@400;500;600&family=IBM+Plex+Mono:wght@500;600&display=swap');";

const C = {
  ink: "#23261F",
  inkSoft: "#2E3227",
  panel: "#F4F0E4",
  panelEdge: "#DDD6C2",
  bone: "#EFE8D8",
  boneDim: "#B9B199",
  ochre: "#C98A2C",
  ochreDeep: "#9C6A1E",
  rust: "#A3502E",
  sage: "#6F8055",
  stone: "#7A7561",
};

const BREEDS = [
  "Speckle Park",
  "Angus",
  "Brahman",
  "Charolais",
  "Hereford",
  "Droughtmaster",
  "Wagyu",
  "Santa Gertrudis",
  "Simmental",
];

const SIMPLE_CATEGORIES = ["Steers", "Heifers", "Cows", "Bulls"];
const ALL_CATEGORIES = [
  "Steers",
  "Heifers",
  "Cows",
  "Bulls",
  "PTIC Heifers",
  "Cows & Calves",
  "Weaners",
  "Feeders",
  "Breeders",
  "Mixed Mob",
];

const PRICE_TYPES = ["$/head", "c/kg lwt", "c/kg dwt"];

/* ---------------------------------------------------------------
   Mock listings — standing in for AuctionsPlus / TopX / Nutrien /
   Ray White Rural / GDL feeds and farmer-submitted links.
   Distances are straight-line from Harlin, QLD for this demo.
---------------------------------------------------------------- */
const LISTINGS = [
  { id: 1, breed: "Speckle Park", cross: true, category: "Feeders", head: 24, avgWeight: 382, weightRange: [350, 410], mixed: true, priceType: "c/kg lwt", price: 435, location: "Dalby, QLD", distance: 240, saleDate: "16 Sep", source: "AuctionsPlus", trusted: true, splittable: false },
  { id: 2, breed: "Speckle Park", cross: false, category: "PTIC Heifers", head: 18, avgWeight: 347, weightRange: null, mixed: false, priceType: "$/head", price: 1490, location: "Roma, QLD", distance: 510, saleDate: "20 Sep", source: "Nutrien", trusted: true, splittable: false },
  { id: 3, breed: "Speckle Park", cross: true, category: "Feeders", head: 42, avgWeight: 425, weightRange: null, mixed: false, priceType: "POA", price: null, location: "Warwick, QLD", distance: 190, saleDate: "14 Sep", source: "Farmer submitted", trusted: false, splittable: false },
  { id: 4, breed: "Angus", cross: false, category: "Weaners", head: 60, avgWeight: 260, weightRange: [220, 300], mixed: true, priceType: "c/kg lwt", price: 410, location: "Toowoomba, QLD", distance: 130, saleDate: "17 Sep", source: "AuctionsPlus", trusted: true, splittable: true },
  { id: 5, breed: "Angus", cross: true, category: "Breeders", head: 30, avgWeight: 400, weightRange: null, mixed: false, priceType: "$/head", price: 1650, location: "Gympie, QLD", distance: 160, saleDate: "22 Sep", source: "Ray White Rural", trusted: true, splittable: false },
  { id: 6, breed: "Brahman", cross: false, category: "Feeders", head: 96, avgWeight: null, weightRange: [380, 480], mixed: true, priceType: "c/kg lwt", price: 398, location: "Roma, QLD", distance: 510, saleDate: "20 Sep", source: "TopX", trusted: true, splittable: true },
  { id: 7, breed: "Charolais", cross: true, category: "Bulls", head: 4, avgWeight: 620, weightRange: null, mixed: false, priceType: "$/head", price: 3200, location: "Kingaroy, QLD", distance: 60, saleDate: "19 Sep", source: "GDL", trusted: true, splittable: false },
  { id: 8, breed: "Hereford", cross: false, category: "Cows & Calves", head: 22, avgWeight: null, weightRange: null, mixed: false, priceType: "$/head", price: 1980, location: "Stanthorpe, QLD", distance: 220, saleDate: "23 Sep", source: "AuctionsPlus", trusted: true, splittable: false },
  { id: 9, breed: "Droughtmaster", cross: true, category: "Feeders", head: 55, avgWeight: 355, weightRange: [330, 380], mixed: true, priceType: "c/kg lwt", price: 402, location: "Biloela, QLD", distance: 480, saleDate: "18 Sep", source: "AuctionsPlus", trusted: true, splittable: true },
  { id: 10, breed: "Wagyu", cross: true, category: "Feeders", head: 15, avgWeight: 300, weightRange: null, mixed: false, priceType: "c/kg lwt", price: 460, location: "Kilcoy, QLD", distance: 40, saleDate: "15 Sep", source: "Farmer submitted", trusted: false, splittable: false },
  { id: 11, breed: "Speckle Park", cross: false, category: "Feeders", head: 12, avgWeight: 315, weightRange: null, mixed: false, priceType: "$/head", price: 1580, location: "Nanango, QLD", distance: 55, saleDate: "14 Sep", source: "AuctionsPlus", trusted: true, splittable: false },
  { id: 12, breed: "Santa Gertrudis", cross: false, category: "PTIC Heifers", head: 26, avgWeight: 430, weightRange: null, mixed: false, priceType: "$/head", price: 1720, location: "Monto, QLD", distance: 340, saleDate: "24 Sep", source: "Nutrien", trusted: true, splittable: false },
  { id: 13, breed: "Simmental", cross: true, category: "Feeders", head: 33, avgWeight: 470, weightRange: null, mixed: false, priceType: "c/kg dwt", price: 620, location: "Casino, NSW", distance: 610, saleDate: "21 Sep", source: "TopX", trusted: true, splittable: false },
  { id: 14, breed: "Speckle Park", cross: true, category: "Mixed Mob", head: 50, avgWeight: null, weightRange: [280, 420], mixed: true, priceType: "POA", price: null, location: "Chinchilla, QLD", distance: 300, saleDate: "19 Sep", source: "AuctionsPlus", trusted: true, splittable: true },
];

const emptyFilters = {
  breeds: [],
  breedType: "both", // purebred | crossbred | both
  categories: [],
  weightMin: "",
  weightMax: "",
  includeMixed: true,
  priceTypes: [],
  includePOA: true,
  radius: 700,
  headMin: "",
  headMax: "",
  allowSplit: true,
};

const exampleFilters = {
  ...emptyFilters,
  breeds: ["Speckle Park"],
  breedType: "both",
  categories: ["Steers", "Heifers", "Feeders"],
  weightMin: "320",
  weightMax: "",
  includeMixed: true,
  radius: 700,
};

function matchesFilters(l, f) {
  if (f.breeds.length) {
    if (!f.breeds.includes(l.breed)) return false;
    if (f.breedType === "purebred" && l.cross) return false;
    if (f.breedType === "crossbred" && !l.cross) return false;
  }
  if (f.categories.length && !f.categories.includes(l.category)) return false;

  const min = f.weightMin === "" ? null : Number(f.weightMin);
  const max = f.weightMax === "" ? null : Number(f.weightMax);
  if (min !== null || max !== null) {
    if (l.avgWeight != null) {
      const okMin = min === null || l.avgWeight >= min;
      const okMax = max === null || l.avgWeight <= max;
      if (!(okMin && okMax)) return false;
    } else if (l.weightRange) {
      const [lo, hi] = l.weightRange;
      const overlaps =
        (min === null || hi >= min) && (max === null || lo <= max);
      const fullyInside =
        (min === null || lo >= min) && (max === null || hi <= max);
      if (!fullyInside) {
        if (!(f.includeMixed && overlaps)) return false;
      }
    }
  }

  if (f.priceTypes.length) {
    if (l.priceType === "POA") {
      if (!f.includePOA) return false;
    } else if (!f.priceTypes.includes(l.priceType)) {
      return false;
    }
  }

  if (l.distance > f.radius) return false;

  const hMin = f.headMin === "" ? null : Number(f.headMin);
  const hMax = f.headMax === "" ? null : Number(f.headMax);
  if (hMin !== null && l.head < hMin) return false;
  if (hMax !== null && l.head > hMax) {
    if (!(f.allowSplit && l.splittable)) return false;
  }

  return true;
}

function landedPerHead(l, freightRate) {
  const freightPerHead = (l.distance * freightRate) / l.head;
  let base = null;
  if (l.priceType === "$/head") base = l.price;
  else if (l.priceType === "c/kg lwt") {
    const w = l.avgWeight ?? (l.weightRange ? (l.weightRange[0] + l.weightRange[1]) / 2 : null);
    if (w) base = (l.price / 100) * w;
  }
  return { freightPerHead, landed: base != null ? base + freightPerHead : null };
}

function fmt$(n) {
  return n.toLocaleString("en-AU", { maximumFractionDigits: 0 });
}

/* ---------------------------------------------------------------
   Small UI atoms
---------------------------------------------------------------- */
function Chip({ active, onClick, children }) {
  return (
    <button
      onClick={onClick}
      style={{
        fontFamily: "Inter",
        fontSize: 13,
        fontWeight: 500,
        padding: "7px 13px",
        borderRadius: 7,
        border: `1px solid ${active ? C.ochreDeep : C.panelEdge}`,
        background: active ? C.ochre : "transparent",
        color: active ? C.ink : C.ink,
        cursor: "pointer",
        whiteSpace: "nowrap",
      }}
    >
      {children}
    </button>
  );
}

function SectionLabel({ children }) {
  return (
    <div
      style={{
        fontFamily: "Oswald",
        fontSize: 13,
        fontWeight: 600,
        letterSpacing: 0.2,
        color: C.stone,
        marginBottom: 8,
      }}
    >
      {children}
    </div>
  );
}

function NumberField({ value, onChange, placeholder, width = 78 }) {
  return (
    <input
      value={value}
      onChange={(e) => onChange(e.target.value.replace(/[^0-9]/g, ""))}
      placeholder={placeholder}
      inputMode="numeric"
      style={{
        width,
        fontFamily: "IBM Plex Mono",
        fontSize: 14,
        fontWeight: 600,
        padding: "8px 10px",
        borderRadius: 6,
        border: `1px solid ${C.panelEdge}`,
        background: "#FCFAF3",
        color: C.ink,
      }}
    />
  );
}

function Toggle({ checked, onChange, label }) {
  return (
    <button
      onClick={() => onChange(!checked)}
      style={{
        display: "flex",
        alignItems: "center",
        gap: 8,
        background: "none",
        border: "none",
        cursor: "pointer",
        padding: 0,
      }}
    >
      <div
        style={{
          width: 34,
          height: 20,
          borderRadius: 10,
          background: checked ? C.ochre : C.panelEdge,
          position: "relative",
          transition: "background .15s",
          flexShrink: 0,
        }}
      >
        <div
          style={{
            position: "absolute",
            top: 2,
            left: checked ? 16 : 2,
            width: 16,
            height: 16,
            borderRadius: "50%",
            background: "#fff",
            transition: "left .15s",
          }}
        />
      </div>
      <span style={{ fontFamily: "Inter", fontSize: 13.5, color: C.ink, textAlign: "left" }}>
        {label}
      </span>
    </button>
  );
}

/* ---------------------------------------------------------------
   Main app
---------------------------------------------------------------- */
export default function CattleFinderPrototype() {
  const [screen, setScreen] = useState("search");
  const [mode, setMode] = useState("simple");
  const [filters, setFilters] = useState(emptyFilters);
  const [location, setLocation] = useState("Harlin, QLD");
  const [freightRate, setFreightRate] = useState(3.2);
  const [favorites, setFavorites] = useState(new Set());
  const [savedSearches, setSavedSearches] = useState([]);
  const [toast, setToast] = useState(null);
  const [submitUrl, setSubmitUrl] = useState("");
  const [submitBreed, setSubmitBreed] = useState("");
  const [hasSearched, setHasSearched] = useState(false);

  const results = useMemo(
    () => LISTINGS.filter((l) => matchesFilters(l, filters)),
    [filters]
  );

  function setF(patch) {
    setFilters((f) => ({ ...f, ...patch }));
  }
  function toggleInArray(key, value) {
    setFilters((f) => {
      const arr = f[key].includes(value)
        ? f[key].filter((x) => x !== value)
        : [...f[key], value];
      return { ...f, [key]: arr };
    });
  }
  function flashToast(msg) {
    setToast(msg);
    setTimeout(() => setToast(null), 2200);
  }
  function runSearch() {
    setHasSearched(true);
    setScreen("feed");
  }
  function loadExample() {
    setFilters(exampleFilters);
    setHasSearched(true);
    setMode("advanced");
    setScreen("feed");
  }
  function toggleFavorite(id) {
    setFavorites((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  }
  function saveCurrentSearch() {
    const label =
      (filters.breeds[0] || "All breeds") +
      (filters.categories.length ? ` · ${filters.categories.join("/")}` : "");
    setSavedSearches((s) => [{ id: Date.now(), label, filters }, ...s]);
    flashToast("Search saved");
  }
  function runSavedSearch(s) {
    setFilters(s.filters);
    setScreen("feed");
  }
  function removeSavedSearch(id) {
    setSavedSearches((s) => s.filter((x) => x.id !== id));
  }
  function submitListing() {
    if (!submitUrl.trim()) return;
    flashToast("Sent for review");
    setSubmitUrl("");
    setSubmitBreed("");
  }

  return (
    <div
      style={{
        minHeight: "100vh",
        display: "flex",
        justifyContent: "center",
        alignItems: "flex-start",
        background: "#191B16",
        padding: "24px 12px",
        fontFamily: "Inter",
      }}
    >
      <style>{`${FONT_IMPORT}
        * { box-sizing: border-box; }
        ::-webkit-scrollbar { width: 0; height: 0; }
      `}</style>

      {/* Phone frame */}
      <div
        style={{
          width: 390,
          maxWidth: "100%",
          height: 780,
          background: C.panel,
          borderRadius: 34,
          border: `8px solid ${C.ink}`,
          overflow: "hidden",
          display: "flex",
          flexDirection: "column",
          position: "relative",
          boxShadow: "0 30px 60px rgba(0,0,0,.45)",
        }}
      >
        {/* Status/header bar */}
        <div
          style={{
            background: C.ink,
            color: C.bone,
            padding: "18px 20px 16px",
            display: "flex",
            alignItems: "baseline",
            justifyContent: "space-between",
          }}
        >
          <div style={{ fontFamily: "Oswald", fontSize: 21, fontWeight: 700, letterSpacing: 0.3 }}>
            Cattle Finder
          </div>
          <div style={{ fontFamily: "IBM Plex Mono", fontSize: 11.5, color: C.boneDim }}>
            {location}
          </div>
        </div>

        {/* Screen body */}
        <div style={{ flex: 1, overflowY: "auto", padding: "16px 16px 90px" }}>
          {screen === "search" && (
            <SearchScreen
              mode={mode}
              setMode={setMode}
              filters={filters}
              setF={setF}
              toggleInArray={toggleInArray}
              location={location}
              setLocation={setLocation}
              onSearch={runSearch}
              onExample={loadExample}
            />
          )}

          {screen === "feed" && (
            <FeedScreen
              results={results}
              filters={filters}
              onEditSearch={() => setScreen("search")}
              onSave={saveCurrentSearch}
              favorites={favorites}
              toggleFavorite={toggleFavorite}
              freightRate={freightRate}
              setFreightRate={setFreightRate}
              hasSearched={hasSearched}
            />
          )}

          {screen === "saved" && (
            <SavedScreen
              savedSearches={savedSearches}
              onRun={runSavedSearch}
              onRemove={removeSavedSearch}
              favorites={favorites}
              toggleFavorite={toggleFavorite}
              freightRate={freightRate}
            />
          )}

          {screen === "submit" && (
            <SubmitScreen
              submitUrl={submitUrl}
              setSubmitUrl={setSubmitUrl}
              submitBreed={submitBreed}
              setSubmitBreed={setSubmitBreed}
              onSubmit={submitListing}
            />
          )}
        </div>

        {/* Toast */}
        {toast && (
          <div
            style={{
              position: "absolute",
              bottom: 78,
              left: 16,
              right: 16,
              background: C.ink,
              color: C.bone,
              fontFamily: "Inter",
              fontSize: 13.5,
              fontWeight: 500,
              padding: "10px 14px",
              borderRadius: 8,
              display: "flex",
              alignItems: "center",
              gap: 8,
            }}
          >
            <Check size={15} color={C.ochre} /> {toast}
          </div>
        )}

        {/* Bottom nav */}
        <div
          style={{
            position: "absolute",
            bottom: 0,
            left: 0,
            right: 0,
            background: C.ink,
            display: "flex",
            padding: "10px 10px 14px",
            gap: 4,
          }}
        >
          <NavButton icon={Search} label="Search" active={screen === "search"} onClick={() => setScreen("search")} />
          <NavButton icon={ListFilter} label="Feed" active={screen === "feed"} onClick={() => setScreen("feed")} badge={hasSearched ? results.length : null} />
          <NavButton icon={Heart} label="Saved" active={screen === "saved"} onClick={() => setScreen("saved")} badge={favorites.size || null} />
          <NavButton icon={PlusCircle} label="Submit" active={screen === "submit"} onClick={() => setScreen("submit")} />
        </div>
      </div>
    </div>
  );
}

function NavButton({ icon: Icon, label, active, onClick, badge }) {
  return (
    <button
      onClick={onClick}
      style={{
        flex: 1,
        background: "none",
        border: "none",
        cursor: "pointer",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        gap: 3,
        padding: "6px 0",
        position: "relative",
        color: active ? C.ochre : C.boneDim,
      }}
    >
      <Icon size={19} />
      <span style={{ fontFamily: "Inter", fontSize: 10.5, fontWeight: 500 }}>{label}</span>
      {badge ? (
        <span
          style={{
            position: "absolute",
            top: -2,
            right: "28%",
            background: C.rust,
            color: C.bone,
            fontFamily: "IBM Plex Mono",
            fontSize: 9.5,
            fontWeight: 600,
            borderRadius: 8,
            padding: "1px 5px",
          }}
        >
          {badge}
        </span>
      ) : null}
    </button>
  );
}

/* ---------------------------------------------------------------
   Search screen
---------------------------------------------------------------- */
function SearchScreen({ mode, setMode, filters, setF, toggleInArray, location, setLocation, onSearch, onExample }) {
  return (
    <div>
      <button
        onClick={onExample}
        style={{
          width: "100%",
          textAlign: "left",
          background: "#EADFC4",
          border: `1px dashed ${C.ochreDeep}`,
          borderRadius: 8,
          padding: "10px 12px",
          marginBottom: 18,
          cursor: "pointer",
          fontFamily: "Inter",
          fontSize: 12.5,
          color: C.ochreDeep,
          fontWeight: 500,
        }}
      >
        Try an example — Speckle Park, 320kg+, within 700km of Harlin
      </button>

      <SectionLabel>Location & range</SectionLabel>
      <div style={{ display: "flex", gap: 8, marginBottom: 6 }}>
        <div style={{ flex: 1, display: "flex", alignItems: "center", gap: 6, border: `1px solid ${C.panelEdge}`, borderRadius: 6, padding: "8px 10px", background: "#FCFAF3" }}>
          <MapPin size={14} color={C.stone} />
          <input
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            style={{ border: "none", outline: "none", background: "none", fontFamily: "Inter", fontSize: 13.5, width: "100%" }}
          />
        </div>
      </div>
      <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 20 }}>
        <input
          type="range"
          min={50}
          max={1000}
          step={25}
          value={filters.radius}
          onChange={(e) => setF({ radius: Number(e.target.value) })}
          style={{ flex: 1, accentColor: C.ochreDeep }}
        />
        <div style={{ fontFamily: "IBM Plex Mono", fontSize: 13, fontWeight: 600, color: C.ink, minWidth: 62, textAlign: "right" }}>
          {filters.radius} km
        </div>
      </div>

      <div style={{ display: "flex", gap: 6, marginBottom: 18 }}>
        {["simple", "advanced"].map((m) => (
          <button
            key={m}
            onClick={() => setMode(m)}
            style={{
              flex: 1,
              padding: "8px 0",
              borderRadius: 7,
              border: `1px solid ${C.panelEdge}`,
              background: mode === m ? C.ink : "transparent",
              color: mode === m ? C.bone : C.ink,
              fontFamily: "Oswald",
              fontSize: 12.5,
              fontWeight: 600,
              letterSpacing: 0.3,
              cursor: "pointer",
              textTransform: "capitalize",
            }}
          >
            {m === "simple" ? "Simple search" : "Advanced search"}
          </button>
        ))}
      </div>

      <SectionLabel>Breed</SectionLabel>
      <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 14 }}>
        {BREEDS.map((b) => (
          <Chip key={b} active={filters.breeds.includes(b)} onClick={() => toggleInArray("breeds", b)}>
            {b}
          </Chip>
        ))}
      </div>

      {mode === "advanced" && (
        <div style={{ display: "flex", gap: 6, marginBottom: 20 }}>
          {[
            ["both", "Purebred + crosses"],
            ["purebred", "Purebred only"],
            ["crossbred", "Crossbred only"],
          ].map(([val, label]) => (
            <Chip key={val} active={filters.breedType === val} onClick={() => setF({ breedType: val })}>
              {label}
            </Chip>
          ))}
        </div>
      )}

      <SectionLabel>Category</SectionLabel>
      <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 20 }}>
        {(mode === "simple" ? SIMPLE_CATEGORIES : ALL_CATEGORIES).map((c) => (
          <Chip key={c} active={filters.categories.includes(c)} onClick={() => toggleInArray("categories", c)}>
            {c}
          </Chip>
        ))}
      </div>

      <SectionLabel>Weight (kg, average liveweight)</SectionLabel>
      <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
        <NumberField value={filters.weightMin} onChange={(v) => setF({ weightMin: v })} placeholder="Min" />
        <span style={{ color: C.stone, fontFamily: "Inter", fontSize: 13 }}>to</span>
        <NumberField value={filters.weightMax} onChange={(v) => setF({ weightMax: v })} placeholder="Max" />
      </div>
      <div style={{ marginBottom: 20 }}>
        <Toggle checked={filters.includeMixed} onChange={(v) => setF({ includeMixed: v })} label="Include mixed-weight mobs that partly fall outside this range" />
      </div>

      {mode === "advanced" && (
        <>
          <SectionLabel>Price</SectionLabel>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 10 }}>
            {PRICE_TYPES.map((p) => (
              <Chip key={p} active={filters.priceTypes.includes(p)} onClick={() => toggleInArray("priceTypes", p)}>
                {p}
              </Chip>
            ))}
          </div>
          <div style={{ marginBottom: 20 }}>
            <Toggle checked={filters.includePOA} onChange={(v) => setF({ includePOA: v })} label="Include listings marked price on application" />
          </div>

          <SectionLabel>Head count</SectionLabel>
          <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
            <NumberField value={filters.headMin} onChange={(v) => setF({ headMin: v })} placeholder="Min" />
            <span style={{ color: C.stone, fontFamily: "Inter", fontSize: 13 }}>to</span>
            <NumberField value={filters.headMax} onChange={(v) => setF({ headMax: v })} placeholder="Max" />
          </div>
          <div style={{ marginBottom: 22 }}>
            <Toggle checked={filters.allowSplit} onChange={(v) => setF({ allowSplit: v })} label="Include larger mobs the seller is willing to split" />
          </div>
        </>
      )}

      <button
        onClick={onSearch}
        style={{
          width: "100%",
          background: C.ochre,
          border: "none",
          borderRadius: 8,
          padding: "13px 0",
          fontFamily: "Oswald",
          fontSize: 15,
          fontWeight: 600,
          letterSpacing: 0.3,
          color: C.ink,
          cursor: "pointer",
        }}
      >
        Search cattle
      </button>
    </div>
  );
}

/* ---------------------------------------------------------------
   Feed screen
---------------------------------------------------------------- */
function FeedScreen({ results, filters, onEditSearch, onSave, favorites, toggleFavorite, freightRate, setFreightRate, hasSearched }) {
  const summary =
    (filters.breeds.length ? filters.breeds.join(", ") : "All breeds") +
    (filters.categories.length ? ` · ${filters.categories.join(", ")}` : "") +
    (filters.weightMin || filters.weightMax
      ? ` · ${filters.weightMin || "0"}–${filters.weightMax || "∞"}kg`
      : "") +
    ` · ${filters.radius}km`;

  if (!hasSearched) {
    return (
      <EmptyState
        title="No search run yet"
        body="Set your filters on the Search tab, or try the example search, to see matching cattle here."
      />
    );
  }

  return (
    <div>
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "flex-start",
          gap: 10,
          marginBottom: 12,
        }}
      >
        <div>
          <div style={{ fontFamily: "Oswald", fontSize: 15, fontWeight: 600, color: C.ink }}>
            {results.length} match{results.length === 1 ? "" : "es"}
          </div>
          <div style={{ fontFamily: "Inter", fontSize: 11.5, color: C.stone, marginTop: 2 }}>{summary}</div>
        </div>
        <div style={{ display: "flex", gap: 6 }}>
          <IconTextButton icon={SlidersHorizontal} onClick={onEditSearch} label="Edit" />
          <IconTextButton icon={Heart} onClick={onSave} label="Save" />
        </div>
      </div>

      <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 14, background: "#EADFC4", padding: "7px 10px", borderRadius: 7 }}>
        <Truck size={14} color={C.ochreDeep} />
        <span style={{ fontFamily: "Inter", fontSize: 11.5, color: C.ochreDeep }}>Freight estimate rate:</span>
        <input
          type="number"
          step="0.1"
          value={freightRate}
          onChange={(e) => setFreightRate(Number(e.target.value))}
          style={{ width: 46, fontFamily: "IBM Plex Mono", fontSize: 12, fontWeight: 600, border: "none", background: "none", color: C.ink }}
        />
        <span style={{ fontFamily: "Inter", fontSize: 11.5, color: C.ochreDeep }}>$/km — edit to match your carrier</span>
      </div>

      {results.length === 0 ? (
        <EmptyState title="Nothing matches yet" body="Widen the weight range, include mixed mobs, or raise the search radius and try again." />
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {results.map((l) => (
            <ListingCard
              key={l.id}
              l={l}
              favored={favorites.has(l.id)}
              onFavorite={() => toggleFavorite(l.id)}
              freightRate={freightRate}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function IconTextButton({ icon: Icon, label, onClick }) {
  return (
    <button
      onClick={onClick}
      style={{
        display: "flex",
        alignItems: "center",
        gap: 5,
        background: "none",
        border: `1px solid ${C.panelEdge}`,
        borderRadius: 6,
        padding: "6px 10px",
        cursor: "pointer",
        fontFamily: "Inter",
        fontSize: 11.5,
        color: C.ink,
      }}
    >
      <Icon size={13} /> {label}
    </button>
  );
}

function ListingCard({ l, favored, onFavorite, freightRate }) {
  const { freightPerHead, landed } = landedPerHead(l, freightRate);
  const weightLine = l.avgWeight
    ? `avg ${l.avgWeight}kg`
    : l.weightRange
    ? `${l.weightRange[0]}–${l.weightRange[1]}kg`
    : "weight not listed";

  return (
    <div
      style={{
        display: "flex",
        borderRadius: 8,
        overflow: "hidden",
        background: "#FCFAF3",
        border: `1px solid ${C.panelEdge}`,
      }}
    >
      <div style={{ width: 5, background: l.trusted ? C.sage : C.rust, flexShrink: 0 }} />
      <div style={{ flex: 1, padding: "11px 12px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
          <div style={{ fontFamily: "Oswald", fontSize: 14.5, fontWeight: 600, color: C.ink }}>
            {l.head} {l.breed}
            {l.cross ? " X" : ""} {l.category}
          </div>
          <button onClick={onFavorite} style={{ background: "none", border: "none", cursor: "pointer", padding: 0 }}>
            <Heart size={17} color={favored ? C.rust : C.boneDim} fill={favored ? C.rust : "none"} />
          </button>
        </div>

        <div style={{ display: "flex", flexWrap: "wrap", gap: 10, marginTop: 5 }}>
          <MonoStat label="Weight" value={weightLine} />
          {l.mixed && (
            <span style={{ fontFamily: "Inter", fontSize: 10.5, fontWeight: 600, color: C.ochreDeep, background: "#EADFC4", borderRadius: 5, padding: "2px 6px", alignSelf: "center" }}>
              Mixed weight
            </span>
          )}
        </div>

        <div style={{ display: "flex", flexWrap: "wrap", gap: 12, marginTop: 6 }}>
          <MonoStat
            label="Price"
            value={l.priceType === "POA" ? "POA" : `${l.priceType === "$/head" ? "$" : ""}${fmt$(l.price)}${l.priceType !== "$/head" ? " " + l.priceType.replace("c/kg ", "c/kg ") : ""}`}
          />
          <MonoStat label="Freight est." value={`$${freightPerHead.toFixed(0)}/hd`} />
          {landed != null && <MonoStat label="Landed est." value={`$${fmt$(Math.round(landed))}/hd`} />}
        </div>

        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 9, paddingTop: 8, borderTop: `1px dashed ${C.panelEdge}` }}>
          <div style={{ fontFamily: "Inter", fontSize: 11, color: C.stone, display: "flex", alignItems: "center", gap: 4 }}>
            <MapPin size={11} /> {l.location} · {l.distance}km
          </div>
          <div style={{ fontFamily: "Inter", fontSize: 11, color: C.stone, display: "flex", alignItems: "center", gap: 4 }}>
            {l.trusted ? <BadgeCheck size={12} color={C.sage} /> : <Clock3 size={12} color={C.rust} />}
            {l.source}
          </div>
        </div>
        <a
          href="#"
          onClick={(e) => e.preventDefault()}
          style={{ display: "inline-flex", alignItems: "center", gap: 4, marginTop: 7, fontFamily: "Inter", fontSize: 11.5, fontWeight: 600, color: C.ochreDeep, textDecoration: "none" }}
        >
          <Link2 size={12} /> View original listing <ChevronRight size={12} />
        </a>
      </div>
    </div>
  );
}

function MonoStat({ label, value }) {
  return (
    <div>
      <div style={{ fontFamily: "Inter", fontSize: 9.5, color: C.stone, textTransform: "uppercase" }}>{label}</div>
      <div style={{ fontFamily: "IBM Plex Mono", fontSize: 12.5, fontWeight: 600, color: C.ink }}>{value}</div>
    </div>
  );
}

function EmptyState({ title, body }) {
  return (
    <div style={{ textAlign: "center", padding: "50px 12px", color: C.stone }}>
      <div style={{ fontFamily: "Oswald", fontSize: 15, fontWeight: 600, color: C.ink, marginBottom: 6 }}>{title}</div>
      <div style={{ fontFamily: "Inter", fontSize: 12.5, lineHeight: 1.5 }}>{body}</div>
    </div>
  );
}

/* ---------------------------------------------------------------
   Saved screen
---------------------------------------------------------------- */
function SavedScreen({ savedSearches, onRun, onRemove, favorites, toggleFavorite, freightRate }) {
  const favoredListings = LISTINGS.filter((l) => favorites.has(l.id));
  return (
    <div>
      <SectionLabel>Saved searches</SectionLabel>
      {savedSearches.length === 0 ? (
        <div style={{ fontFamily: "Inter", fontSize: 12.5, color: C.stone, marginBottom: 22 }}>
          Save a search from the Feed tab to get alerts when new cattle match it.
        </div>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: 8, marginBottom: 22 }}>
          {savedSearches.map((s) => (
            <div
              key={s.id}
              style={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                background: "#FCFAF3",
                border: `1px solid ${C.panelEdge}`,
                borderRadius: 8,
                padding: "9px 11px",
              }}
            >
              <button
                onClick={() => onRun(s)}
                style={{ background: "none", border: "none", cursor: "pointer", textAlign: "left", fontFamily: "Inter", fontSize: 12.5, color: C.ink, flex: 1 }}
              >
                {s.label}
              </button>
              <button onClick={() => onRemove(s.id)} style={{ background: "none", border: "none", cursor: "pointer" }}>
                <Trash2 size={14} color={C.stone} />
              </button>
            </div>
          ))}
        </div>
      )}

      <SectionLabel>Favourited listings</SectionLabel>
      {favoredListings.length === 0 ? (
        <div style={{ fontFamily: "Inter", fontSize: 12.5, color: C.stone }}>
          Tap the heart on a listing in the Feed to keep it here.
        </div>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {favoredListings.map((l) => (
            <ListingCard key={l.id} l={l} favored={true} onFavorite={() => toggleFavorite(l.id)} freightRate={freightRate} />
          ))}
        </div>
      )}
    </div>
  );
}

/* ---------------------------------------------------------------
   Submit screen
---------------------------------------------------------------- */
function SubmitScreen({ submitUrl, setSubmitUrl, submitBreed, setSubmitBreed, onSubmit }) {
  return (
    <div>
      <SectionLabel>Submit a listing</SectionLabel>
      <div style={{ fontFamily: "Inter", fontSize: 12.5, color: C.stone, marginBottom: 18, lineHeight: 1.5 }}>
        Paste a link to a sale listing — from an agent, saleyard catalogue, or your own advertisement. Listings from
        recognised sources appear straight away; anything else goes to a short review queue first.
      </div>

      <SectionLabel>Listing link</SectionLabel>
      <input
        value={submitUrl}
        onChange={(e) => setSubmitUrl(e.target.value)}
        placeholder="https://…"
        style={{
          width: "100%",
          fontFamily: "Inter",
          fontSize: 13,
          padding: "10px 11px",
          borderRadius: 7,
          border: `1px solid ${C.panelEdge}`,
          background: "#FCFAF3",
          marginBottom: 16,
        }}
      />

      <SectionLabel>Breed</SectionLabel>
      <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 22 }}>
        {BREEDS.map((b) => (
          <Chip key={b} active={submitBreed === b} onClick={() => setSubmitBreed(b)}>
            {b}
          </Chip>
        ))}
      </div>

      <button
        onClick={onSubmit}
        disabled={!submitUrl.trim()}
        style={{
          width: "100%",
          background: submitUrl.trim() ? C.ochre : C.panelEdge,
          border: "none",
          borderRadius: 8,
          padding: "13px 0",
          fontFamily: "Oswald",
          fontSize: 15,
          fontWeight: 600,
          letterSpacing: 0.3,
          color: C.ink,
          cursor: submitUrl.trim() ? "pointer" : "default",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          gap: 8,
        }}
      >
        <Send size={15} /> Send for review
      </button>
    </div>
  );
}
