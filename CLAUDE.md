# Portfolio – CLAUDE.md

A single-page software portfolio built with **Svelte 5 + Vite**. No router. No SSR.

A fixed hero (name + title) that shrinks and tucks into the top-left corner as you scroll, a UR10 3D model that auto-rotates while the hero is in view and fades out once you scroll past it, a globally-shared toggle switch in the top-right that everyone on the site shares state with, and a stack of `100vh` placeholder section panels (about / projects / experience / contact) with a fixed sidebar on the right that has a scroll-progress fill and section jump links.

The switch is backed by a small Python/FastAPI service (see `server/`) that persists a single click count to disk.

---

## Project Structure

```
src/
├── App.svelte             # Root – hero, panels, owns scroll/resize listeners and CSS tokens
├── main.js                # Vite entry point
└── lib/
    ├── RobotViewer.svelte # Fixed <model-viewer> of ur10.glb; fades out past hero
    ├── Sidebar.svelte     # Right-side fixed nav: progress fill + jump-to buttons
    └── Switch.svelte      # Top-right global click counter / toggle, polls /api/clicks

public/
└── ur10.glb               # Robot model loaded by RobotViewer

server/
├── main.py                # FastAPI app: GET/POST /api/clicks
├── requirements.txt       # fastapi, uvicorn
└── clicks.txt             # Persisted click total (gitignored, created on first POST)
```

Frontend deps: `svelte ^5`, `vite ^6`, `@google/model-viewer ^4` (web component, registered by side-effect import in `RobotViewer.svelte`).

Backend deps: `fastapi`, `uvicorn`. No DB.

---

## Dev Commands

Run the frontend and backend in two terminals:

```bash
# terminal 1 – frontend
npm run dev      # http://localhost:5173
npm run build    # → dist/
npm run preview  # serve the production build locally

# terminal 2 – backend
cd server
python3 -m venv .venv                      # first time only
.venv/bin/pip install -r requirements.txt  # first time only
.venv/bin/uvicorn main:app --reload --port 8000 --workers 1
```

Or, with the venv activated (`source server/.venv/bin/activate`), `uvicorn main:app --reload --port 8000 --workers 1` directly.

Vite is configured to proxy `/api/*` → `http://localhost:8000` (see `vite.config.js`), so the frontend always uses relative paths and the same code works in dev and behind a reverse proxy in prod.

---

## Shared scroll state

`App.svelte` owns the only `scroll` and `resize` listeners. It writes three unitless numbers onto `document.documentElement`:

- `--scroll` = `window.scrollY` (updated on every scroll event)
- `--vh` = `window.innerHeight` (updated on resize)
- `--page-height` = `documentElement.scrollHeight` (updated on resize)

A derived token rides on top:

- `--t` = `clamp(0, --scroll / --vh, 1)` — hero-progress in `[0, 1]`. `0` at the top of the page, `1` once you've scrolled one viewport.

All four inherit through the entire tree via CSS, so any element can read them in `calc()` without prop drilling and without its own listener.

---

## Hero collapse (`--t`-driven)

`.hero-text` is `position: fixed` and interpolates several properties on `--t`:

| Property | At `--t = 0` | At `--t = 1` |
|----------|--------------|--------------|
| `top`    | `10vw`       | `2vh`        |
| `left`   | `2vw`        | `2vh`        |
| `.name` font-size | `5rem` | `1.25rem` |
| `.title` font-size | `1rem` | `0.7rem` |
| `.title` margin-top | `1rem` | `0.25rem` |
| padding | `0` | `0.5rem 0.85rem` |
| background | transparent | `rgba(14,14,14,0.45)` |
| backdrop-filter | none | `blur(10px)` |

Net effect: hero starts large and roughly centered-left in the first viewport, then shrinks into a small glass pill in the top-left corner as you scroll one viewport down.

`.hero` itself is a `100vh` empty section with `id="top"` — it provides the scroll runway and the IntersectionObserver target for `RobotViewer`.

---

## RobotViewer

`<model-viewer>` (web component from `@google/model-viewer`) loads `/ur10.glb`, positioned `fixed` near the center of the first viewport (offset left of the hero text). Two behaviors:

- **Fade with hero.** `opacity: calc(1 - var(--t))` — fully visible at the top, gone after one viewport of scroll.
- **Pause when off-screen.** An `IntersectionObserver` on `#top` toggles the `auto-rotate` attribute. When the hero section is intersecting the viewport the model rotates (`rotation-per-second="30deg"`); when it's fully scrolled past, rotation is removed so the GPU isn't doing work nobody can see.

User interaction is disabled (`interaction-prompt="none"`, `disable-zoom`, `disable-tap`, `disable-pan`) and the layer is `pointer-events: none`.

---

## Global Switch

`Switch.svelte` renders a fixed iOS-style toggle in the top-right that mirrors the hero on the left: it starts large and shrinks into the corner as `--t` goes from 0 → 1.

- **Shared state.** The on/off position is `count % 2 === 1`. Everyone on the site sees the same position because they're all reading the same global count.
- **Counter text.** "switch has been flipped X times worldwide" — same Outfit / muted styling as the hero title, shrinks alongside.
- **Click flow.** Optimistic increment locally, `POST /api/clicks`, reconcile from the response. If the request fails (offline, 429, etc.), the optimistic increment is rolled back.
- **Polling.** `setInterval(fetchCount, 5000)`. So when other people click, you see the switch flip and the number tick up within ~5s.

### Backend (`server/main.py`)

FastAPI app with two endpoints:

| Method | Path           | Returns           | Notes                      |
|--------|----------------|-------------------|----------------------------|
| GET    | `/api/clicks`  | `{"count": int}`  | Reads `server/clicks.txt`  |
| POST   | `/api/clicks`  | `{"count": int}`  | Increments and returns new total |

- **Persistence.** Single file `server/clicks.txt` containing the integer total as text. Read returns 0 if the file is missing or empty.
- **Concurrency.** `POST` uses `fcntl.flock(LOCK_EX)` around the read-modify-write, so multiple processes / workers serialize safely. `GET` reads without locking (a torn read is at worst one click off and self-heals on the next request).
- **Rate limit.** In-memory deque per client IP, **100 requests per 10 seconds**. Over the limit returns `429`. The deque is per-process, so this assumes 1 worker (see below) — multi-worker would loosen the effective limit by N×.
- **CORS.** `http://localhost:5173` is allowlisted for direct access in case you bypass the Vite proxy. In prod (same-origin via reverse proxy) CORS is a no-op.
- **Worker count.** Run with `--workers 1`. The file lock would handle multi-worker writes correctly, but the rate limiter's state is per-process. If you ever need to scale, move the rate limit out of memory (Redis, etc.).

### When the schema changes

If you change the response shape (e.g. add a `state` field, switch to a JSON file), update both `Switch.svelte` and the response model here. The frontend currently destructures `{ count }` and ignores everything else.

---

## Sections & Sidebar

`sections` is defined as a single array in `App.svelte`:

```js
const sections = [
  { id: 'top', label: 'Top' },
  { id: 'about', label: 'About' },
  { id: 'projects', label: 'Projects' },
  { id: 'experience', label: 'Experience' },
  { id: 'contact', label: 'Contact' },
];
```

The same array drives:

- **Sidebar buttons** — every entry, in order. Click handler is `document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })`.
- **Panel elements** — `sections.slice(1)`. The `top` entry exists only as a sidebar jump target; the actual `#top` element is the hero section itself, so it isn't re-rendered as a panel.

To add or rename sections: edit the array. The panels and sidebar buttons regenerate automatically. To change which entries get rendered as panels (e.g. omit a label-only target), adjust the slice.

`Sidebar.svelte` is `position: fixed; right: 0; width: var(--sidebar-width); z-index: 3` with `pointer-events: none` on the wrapper and `pointer-events: auto` on the buttons (so the rest of the sidebar surface is click-through). The progress fill height is computed purely in CSS:

```css
height: calc(var(--scroll) / max(1, var(--page-height) - var(--vh)) * 100%);
```

---

## Layout contract: sidebar gutter

The sidebar reserves `--sidebar-width` (110px, defined on `:root` in `App.svelte`) on the right edge of every viewport. Two rules keep panel content from sliding under it:

1. `.panel` sets `padding: 0 var(--sidebar-width) 0 2rem` so its flex centering happens in the area to the *left* of the sidebar.
2. Anything inside a panel that wants to span the panel width should use `width: 100%`, **not** `100vw` — `100vw` ignores the panel padding and bleeds under the sidebar.

If you change the sidebar width, only update `--sidebar-width` on `:root`. Both the sidebar's own `width` and the panel right-padding read from it.

---

## Theme

Single dark palette baked onto `:root` in `App.svelte`. No theme toggle. Tokens:

| Token             | Purpose                                          |
|-------------------|--------------------------------------------------|
| `--bg`            | Page background                                  |
| `--surface`       | (unused for now, reserved)                       |
| `--border`        | Sidebar progress track                           |
| `--text`          | Primary body text / name                         |
| `--text-muted`    | Title, panel labels, sidebar text + progress fill |
| `--accent`        | Switch focus-visible outline                     |
| `--scroll`        | Live `window.scrollY` (set by JS)                |
| `--vh`            | Live `window.innerHeight` (set by JS)            |
| `--page-height`   | Live `documentElement.scrollHeight` (set by JS)  |
| `--t`             | `clamp(0, --scroll / --vh, 1)` — hero progress   |
| `--sidebar-width` | Right-edge gutter reserved for the sidebar       |

Body scrollbar is hidden globally (`scrollbar-width: none` + `::-webkit-scrollbar { display: none }`) so the sidebar's progress fill is the only scroll indicator.

---

## Fonts

Loaded from Google Fonts in `App.svelte`'s `<svelte:head>`:

- **Outfit** (300, 400, 500, 800) — used everywhere. Name uses 800; title and sidebar buttons use 400/500.
