# Portfolio – CLAUDE.md

A single-page software/engineering portfolio built with **Svelte + Vite**. No router. No SSR. Just components.

---

## Project Structure

```
src/
├── App.svelte          # Root – theme store, section data, modal state
├── main.js             # Vite entry point
└── lib/
    ├── Header.svelte   # Top bar: name (left) + theme toggle + avatar (right)
    ├── Section.svelte  # Colored content block with label strip
    └── Modal.svelte    # Popup canvas triggered by "Expand" buttons
```

---

## Dev Commands

```bash
npm run dev      # Start local dev server (http://localhost:5173)
npm run build    # Production build → dist/
npm run preview  # Preview the production build locally
```

---

## Theme System

Theme is a **Svelte writable store** defined in `App.svelte` and passed as a prop to `Header.svelte`.

```svelte
export const theme = writable('dark');   // 'dark' | 'light'
```

The store value is bound to `data-theme` on the root `.app` div. All color tokens live in two CSS blocks in `App.svelte`:

```css
:global([data-theme='dark'])  { --bg: ...; --surface: ...; ... }
:global([data-theme='light']) { --bg: ...; --surface: ...; ... }
```

**To change any color**, edit the CSS variables in those two blocks. Every component inherits them automatically — nothing is hardcoded.

### Key Tokens

| Token           | Purpose                              |
|-----------------|--------------------------------------|
| `--bg`          | Page background                      |
| `--surface`     | Cards, modals, header               |
| `--border`      | All borders and dividers            |
| `--text`        | Primary body text                   |
| `--text-muted`  | Labels, placeholders, icons         |
| `--accent`      | Highlights, hover states, name tint |
| `--section-a/b/c/d` | Per-section background tints   |

---

## Adding / Editing Sections

Sections are defined as a plain array in `App.svelte`:

```js
const sections = [
  { id: 'about',      label: 'About',      color: 'var(--section-a)', content: '...' },
  { id: 'projects',   label: 'Projects',   color: 'var(--section-b)', content: '...' },
  { id: 'experience', label: 'Experience', color: 'var(--section-c)', content: '...' },
  { id: 'contact',    label: 'Contact',    color: 'var(--section-d)', content: '...' },
];
```

- **Add a section**: push a new object, add a matching `--section-X` token in both theme blocks.
- **Reorder**: change array order, that's it.
- **Custom layout per section**: swap the `content` string for a dedicated component passed into the `<Section>` slot.

### Section Component API

```svelte
<Section id="projects" label="Projects" color="var(--section-b)">
  <!-- anything goes in the slot -->
</Section>
```

**Spacing knobs** (all in `Section.svelte`):

| Comment label              | What it controls               |
|----------------------------|-------------------------------|
| `← adjust label bar padding` | Padding around the label strip |
| `← adjust section inner padding` | Inner body padding          |
| `← adjust minimum section height` | Min-height of section body |
| `← adjust corner radius`  | `border-radius` of the card    |

---

## Expanding Content (Modal Canvas)

Any section can open a full popup using the shared `Modal` component.

**Pattern in `App.svelte`:**
```svelte
<button on:click={() => openModal('Title', 'content...')}>Expand</button>

{#if modalOpen}
  <Modal title={modalTitle} on:close={closeModal}>
    <!-- rich content, sub-components, etc. -->
  </Modal>
{/if}
```

**To put richer content in a modal**, create a dedicated component (e.g. `lib/modals/ProjectsModal.svelte`) and drop it inside `<Modal>` as a slot child.

**Modal sizing** (in `Modal.svelte`):
```css
width: min(720px, 94vw);   /* ← modal width */
max-height: 80vh;          /* ← modal max height */
```

Close behavior: click backdrop, press `Escape`, or click ✕.

---

## Header

`Header.svelte` receives the theme store and handles the toggle. Customize:

- **Your name**: edit the two `<span>` elements inside `.name`
- **Avatar**: the `<span class="material-icons">person</span>` placeholder — swap for `<img src="..." alt="PFP" />` when you have a photo
- **Avatar size**: `width`/`height` on `.avatar` (default: `36px`)
- **Name size**: `font-size` on `.name` (default: `1.35rem`)

---

## Fonts

Loaded from Google Fonts in `App.svelte`'s `<svelte:head>`:

- **Syne** (800) — display/name/modal titles
- **DM Mono** (300, 400, 500) — body, labels, buttons

To swap fonts, update the `<link>` href and the `font-family` references in `App.svelte`'s global CSS.

---

## Phase 1 Checklist

- [ ] Header with name + avatar placeholder + theme toggle
- [ ] Dark mode default, light mode toggle
- [ ] 4 placeholder sections with distinct background tints
- [ ] `Section` component with labeled strip + slot
- [ ] `Modal` popup canvas with backdrop blur + ESC/click-away to close
- [ ] All spacing/color values annotated with `← adjust` comments
- [ ] Real content (bio, project cards, timeline, contact links)
- [ ] Replace avatar placeholder with actual photo
- [ ] Per-section modal content components
- [ ] Deploy (Vercel / Netlify / GitHub Pages)

---

## Phase 2 Ideas (not built yet)

- `ProjectCard.svelte` — image, title, tags, links
- `Timeline.svelte` — experience entries
- Staggered entrance animations (`animation-delay` per section)
- Subtle noise texture overlay on `--bg`
- Keyboard-navigable section anchors