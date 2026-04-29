# Portfolio – CLAUDE.md

A single-page software portfolio built with **Svelte + Vite**. No router. No SSR.

Hero (name + title) with a parallax X/O decoration layer that the title slides under and blurs as you scroll, followed by `100vh` placeholder section panels (about / projects / experience / contact) and a fixed sidebar with section jump links and a scroll-progress fill.

---

## Project Structure

```
src/
├── App.svelte           # Root – hero, section panels, owns scroll/resize state
├── main.js              # Vite entry point
└── lib/
    ├── Decorations.svelte  # Fixed full-viewport layer; places + animates marks
    ├── Mark.svelte         # Single X or O rendered as inline SVG
    └── Sidebar.svelte      # Right-side fixed nav: progress fill + jump-to buttons
```

---

## Dev Commands

```bash
npm run dev      # http://localhost:5173
npm run build    # → dist/
npm run preview  # serve the production build locally
```

---

## How the Effect Works

**Layering.** `Decorations.svelte` renders a `position: fixed; inset: 0; z-index: 2; pointer-events: none` layer on top of the hero. The hero sits in normal document flow and scrolls at the page's natural rate. The decoration layer is fixed but gets a `translateY` proportional to `scrollY * MARK_SPEED`, so the marks scroll at a fraction of page speed (default 0.5×). Result: the hero text moves up faster than the marks, so the text passes under them while the marks themselves also drift upward and eventually leave the viewport.

Set `MARK_SPEED = 0` to pin the marks (model "a"), `1` to glue them to the text. In between is true parallax.

**Shared scroll state.** `App.svelte` owns the only `scroll` and `resize` listeners. It writes three unitless numbers onto `document.documentElement`:

- `--scroll` = `window.scrollY` (updated on every scroll event)
- `--vh` = `window.innerHeight` (updated on resize)
- `--page-height` = `documentElement.scrollHeight` (updated on resize)

All three inherit through the entire tree via CSS, so any element can read them in `calc()` without prop drilling and without its own listener.

**Per-element blur (`.scroll-blur`).** A single `:global(.scroll-blur)` rule in `App.svelte` applies a `filter: blur()` whose intensity is computed from each element's *current* viewport Y. Each element opts in by setting two custom properties:

- `--initial-y` — the element's viewport Y (in unitless px) at `scroll = 0`
- `--speed` — how fast its viewport Y changes per scrolled pixel (text uses `1`, marks use `--mark-speed`)

The shared formula computes `currentY = initialY - scroll * speed`, then ramps blur from `0` at `currentY = BLUR_THRESHOLD * vh` up to `BLUR_MAX` near the top, clamped at both ends. Tunable via three `:root` vars in `App.svelte`:

- `--blur-threshold-vh` (default `0.35`) — fraction of viewport height where blur kicks in
- `--blur-rate` (default `0.06`) — px of blur per px past the threshold
- `--blur-max` (default `14px`) — upper bound

Hero text sets `--initial-y: calc(0.5 * var(--vh))` (centered in the first viewport). Marks set `--initial-y: calc(var(--y-pct) * var(--vh) / 100)`, so each mark blurs based on its own height in the viewport — bottom marks stay sharp longer than top marks.

**Scroll length.** `.app` has `min-height: 200vh`, giving one full viewport of scroll past the hero. The empty space below the fold is intentional (it's just there for the effect to play out).

**Placement.** On mount, `Decorations.svelte` runs rejection sampling against `window.innerWidth/innerHeight`:
- 20 marks total, 50/50 X's and O's (alternating array, then shuffled).
- Sizes randomized in `[SIZE_MIN, SIZE_MAX]` px.
- For each mark, sample a random center; reject if it lies within `(size/2 + other.size/2 + PADDING)` of any already-placed mark. Up to `MAX_ATTEMPTS` retries before accepting whatever the last sample was.
- Centers are converted to `%` of viewport size before being passed to `<Mark>`, so positions adapt to window resize. Sizes stay in px.
- Positions are generated once on mount and never re-randomized.

**Rotation.** A single `scroll` listener writes `--scroll` (= `window.scrollY`, unitless) onto the layer root. CSS variables inherit, so each `<Mark>` reads it and computes its own rotation:

```css
transform: translate(-50%, -50%)
  rotate(calc(var(--scroll, 0) * var(--rate) * var(--dir) * 1deg));
```

Each mark gets its own `--rate` (deg per scrolled px, in `[RATE_MIN, RATE_MAX]`) and `--dir` (±1) at placement time, so they spin at different speeds and in mixed directions. Rotation is fully scroll-scrubbed — reverses if you scroll up.

### Tunable knobs (in `Decorations.svelte`)

| Constant | Effect |
|----------|--------|
| `COUNT` | Number of marks |
| `SIZE_MIN` / `SIZE_MAX` | Mark size range (px) |
| `PADDING` | Minimum gap between any two marks (px) |
| `EDGE_MARGIN` | Minimum gap from viewport edges (px) |
| `RATE_MIN` / `RATE_MAX` | Spin speed range (deg per scrolled px) |
| `MARK_SPEED` | Mark scroll speed as fraction of page speed (0 = pinned, 1 = locked to text) |
| `MAX_ATTEMPTS` | Placement retry budget per mark |

To tune the scroll length, change `min-height` on `.app` in `App.svelte`.

---

## Theme

Single dark palette baked onto `:root` in `App.svelte`. No theme toggle. Tokens:

| Token          | Purpose                          |
|----------------|----------------------------------|
| `--bg`         | Page background                  |
| `--surface`    | (unused for now, reserved)       |
| `--border`     | (unused for now, reserved)       |
| `--text`       | Primary body text / name         |
| `--text-muted` | Title, mark color                |
| `--accent`     | (unused for now, reserved)       |
| `--scroll`     | Live `window.scrollY` (set by JS) |
| `--vh`         | Live `window.innerHeight` (set by JS) |
| `--blur-threshold-vh` / `--blur-rate` / `--blur-max` | Scroll-blur tuning |

Marks inherit `color: var(--text-muted)` and use `currentColor` on their SVG strokes — change `--text-muted` to recolor everything muted at once.

---

---

## Sections & Sidebar

`sections` is defined as a single array in `App.svelte`:

```js
const sections = [
  { id: 'about', label: 'About' },
  { id: 'projects', label: 'Projects' },
  { id: 'experience', label: 'Experience' },
  { id: 'contact', label: 'Contact' },
];
```

The same array drives both:
- The placeholder `<section class="panel" id={...}>` elements rendered after the hero (each `min-height: 100vh`, flex-centered).
- The jump-to buttons in `Sidebar.svelte`. Click handler is `document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })`.

To add or rename sections: edit the array. The panels and sidebar buttons regenerate automatically.

`Sidebar.svelte` is `position: fixed; right: 0; width: 110px; z-index: 3` with `pointer-events: none` on the wrapper and `pointer-events: auto` on the buttons (so the rest of the sidebar surface is click-through). The progress fill height is computed purely in CSS:

```css
height: calc(var(--scroll) / max(1, var(--page-height) - var(--vh)) * 100%);
```

---

## Fonts

Loaded from Google Fonts in `App.svelte`'s `<svelte:head>`:

- **Syne** (800) — name
- **DM Mono** (300, 400, 500) — title and body
