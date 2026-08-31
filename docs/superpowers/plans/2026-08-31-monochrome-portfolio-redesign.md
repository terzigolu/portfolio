# Monochrome Portfolio Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Bootstrap resume template with a distinctive, responsive, shadcn-neutral portfolio that foregrounds Yusuf Terzioglu's AI products and engineering experience.

**Architecture:** Keep the current static GitHub Pages delivery model. Rebuild the single page as semantic HTML, a standalone tokenized CSS system, and dependency-free JavaScript for navigation, theme, reveal motion, and scrollspy; validate structure and behavior with Python/Playwright checks before pushing `main`.

**Tech Stack:** HTML5, CSS custom properties, vanilla JavaScript, Python 3 `unittest`, Playwright browser validation, GitHub Pages.

**Spec:** `docs/superpowers/specs/2026-08-31-monochrome-portfolio-redesign.md`

## Global Constraints

- Preserve only claims already present in `index.html`; do not invent achievements, customers, usage numbers, or production claims.
- Dark mode defaults to `#0a0a0a`/`#f5f5f5`; light mode uses `#ffffff`/`#171717` through semantic CSS variables.
- Use Outfit for display, Inter for body, and Geist Mono only for technical utility text.
- Remain static and GitHub Pages-compatible; add no framework, bundler, CMS, contact backend, or analytics integration.
- Support 320px through desktop, keyboard navigation, visible focus, WCAG AA contrast, and `prefers-reduced-motion`.
- Unused Bootstrap/AOS/Typed/PureCounter/Waypoints/Isotope/GLightbox/Swiper assets may remain on disk but must not be loaded by `index.html`.

---

### Task 1: Add an executable page contract

**Files:**
- Create: `tests/test_portfolio.py`
- Modify: `DESIGN.md`
- Test: `tests/test_portfolio.py`

**Interfaces:**
- Consumes: the current static repository and the approved design spec.
- Produces: `PortfolioContractTests`, which later tasks use as the structural acceptance gate, plus the project-wide visual token contract in `DESIGN.md`.

- [ ] **Step 1: Write the failing structural tests**

```python
class PortfolioContractTests(unittest.TestCase):
    def test_primary_sections_exist(self):
        for section_id in ("home", "work", "about", "experience", "contact"):
            self.assertIn(f'id="{section_id}"', self.html)

    def test_old_template_dependencies_are_removed(self):
        for dependency in ("bootstrap.min.css", "aos.css", "typed.umd.js", "purecounter"):
            self.assertNotIn(dependency, self.html.lower())

    def test_accessibility_and_theme_controls_exist(self):
        for marker in ('class="skip-link"', 'id="theme-toggle"', 'aria-label="Toggle color theme"'):
            self.assertIn(marker, self.html)
```

- [ ] **Step 2: Run the contract and confirm the current template fails**

Run: `python3 -m unittest tests/test_portfolio.py -v`

Expected: FAIL because the current page uses `hero`, `portfolio`, Bootstrap, and AOS instead of the new contract.

- [ ] **Step 3: Add `DESIGN.md`**

Define YAML front matter for `colors`, `typography`, `rounded`, `spacing`, and `components`; document the Monochrome Systems Architect overview plus explicit do/don't rules from the spec. The component contract must cover `button`, `card`, `nav`, `proof`, and `timeline`.

- [ ] **Step 4: Verify the design contract**

Run: `npx @google/design.md lint DESIGN.md`

Expected: 0 lint errors. If the tool cannot run without installing a package, report that external-tool limitation and validate the YAML/front matter manually without adding a project dependency.

- [ ] **Step 5: Commit the acceptance contract**

```bash
git add DESIGN.md tests/test_portfolio.py
git commit -m "test: define portfolio redesign contract"
```

### Task 2: Rebuild the semantic page and content hierarchy

**Files:**
- Modify: `index.html`
- Test: `tests/test_portfolio.py`

**Interfaces:**
- Consumes: section IDs and required markers from `PortfolioContractTests`.
- Produces: stable DOM hooks `#site-header`, `#nav-toggle`, `#theme-toggle`, `[data-section]`, `[data-reveal]`, and `[data-theme-icon]` for CSS and JavaScript.

- [ ] **Step 1: Replace template markup with semantic landmarks**

Use this document skeleton while retaining the existing metadata and JSON-LD blocks:

```html
<body>
  <a class="skip-link" href="#main-content">Skip to content</a>
  <header id="site-header" class="site-header">...</header>
  <main id="main-content">
    <section id="home" class="hero" data-section>...</section>
    <section class="proof-strip" aria-label="Career highlights">...</section>
    <section id="work" class="section" data-section>...</section>
    <section id="about" class="section" data-section>...</section>
    <section id="capabilities" class="section">...</section>
    <section id="experience" class="section" data-section>...</section>
    <section id="contact" class="section contact" data-section>...</section>
  </main>
  <footer class="site-footer">...</footer>
</body>
```

- [ ] **Step 2: Replace the hero and navigation**

Add a stable headline, a short grounded description, `View selected work` and `Start a conversation` actions, availability/location, the three-stage `Architect → Build → Operate` system trace, labeled desktop navigation, accessible mobile-menu button, and theme button.

- [ ] **Step 3: Recompose proof, work, about, capabilities, and experience**

Use the existing 10+, 7+, and 500K+ facts; promote ORKAI and Ramorie to large case studies using existing screenshots; show SentScan as supporting work; convert percentage skills into grouped capability rows; retain the resume chronology in a single timeline with older entries visually condensed.

- [ ] **Step 4: Rebuild contact and footer**

Expose email, LinkedIn, GitHub, Istanbul, and the existing phone contact as explicit labeled links. Keep copyright and any legally required template attribution in a quiet footer line.

- [ ] **Step 5: Remove obsolete runtime dependencies from the document**

Keep only favicon, remote font, Bootstrap Icons if used, `assets/css/main.css`, and deferred `assets/js/main.js` references. Do not load Bootstrap CSS/JS, AOS, Typed.js, PureCounter, Waypoints, imagesLoaded, Isotope, GLightbox, or Swiper.

- [ ] **Step 6: Run the structural tests**

Run: `python3 -m unittest tests/test_portfolio.py -v`

Expected: PASS for page structure, dependency removal, links, image attributes, and theme/accessibility markers.

- [ ] **Step 7: Commit semantic page reconstruction**

```bash
git add index.html tests/test_portfolio.py
git commit -m "feat: rebuild portfolio content hierarchy"
```

### Task 3: Implement the monochrome visual system

**Files:**
- Modify: `assets/css/main.css`
- Test: `tests/test_portfolio.py`

**Interfaces:**
- Consumes: semantic classes and `data-*` hooks from Task 2 plus tokens documented in `DESIGN.md`.
- Produces: responsive layouts and states for every visible component, `html[data-theme="light"]`, `.js [data-reveal]`, `.is-visible`, `.nav-open`, and reduced-motion overrides.

- [ ] **Step 1: Replace template CSS with semantic tokens and reset**

Declare the approved background, foreground, surface, muted, border, primary, radius, shadow, font, container, and transition variables. Add light-mode overrides under `html[data-theme="light"]`; remove purple/cyan gradients, glassmorphism, and global text shadows.

- [ ] **Step 2: Style header, hero, and signature trace**

Build a centered sticky header with readable links, a large asymmetric hero, high-contrast actions, and a one-time trace animation. Ensure content is stable before remote fonts load.

- [ ] **Step 3: Style case studies and content sections**

Create alternating product layouts, neutral screenshot frames, a concise portrait/principles composition, grouped capability rows, a single-rail timeline, and a high-contrast contact panel.

- [ ] **Step 4: Add responsive and accessibility states**

Provide breakpoints for 1024px, 768px, 560px, and 360px; visible `:focus-visible`; 44px controls; sticky-header `scroll-margin-top`; mobile menu layout; and no horizontal overflow.

- [ ] **Step 5: Add reveal and reduced-motion behavior**

Hide reveal elements only under `.js`; transition visible elements once; disable smooth scrolling, transforms, trace drawing, and transitions in `prefers-reduced-motion: reduce`.

- [ ] **Step 6: Run static validation**

Run: `python3 -m unittest tests/test_portfolio.py -v && git diff --check`

Expected: all tests pass and no whitespace errors.

- [ ] **Step 7: Commit the visual system**

```bash
git add assets/css/main.css
git commit -m "feat: add monochrome portfolio design system"
```

### Task 4: Implement accessible interactions

**Files:**
- Modify: `assets/js/main.js`
- Test: `tests/test_portfolio.py`

**Interfaces:**
- Consumes: `#site-header`, `#nav-toggle`, `#site-nav`, `#theme-toggle`, `[data-section]`, `[data-reveal]`, and `[data-theme-icon]`.
- Produces: persisted `yt-theme` preference, `aria-expanded` mobile-menu state, active navigation state, `.is-visible` reveal state, and a `.scrolled` header state.

- [ ] **Step 1: Replace vendor initialization with dependency-free functions**

```javascript
const STORAGE_KEY = "yt-theme";
const getPreferredTheme = () => localStorage.getItem(STORAGE_KEY) || "dark";
const applyTheme = (theme) => document.documentElement.dataset.theme = theme;
```

Add guarded initialization so missing optional elements never throw.

- [ ] **Step 2: Implement theme and mobile navigation**

Persist explicit theme selection, update icon/accessible label state, toggle `.nav-open`, maintain `aria-expanded`, close after navigation, close on Escape, and reset at desktop widths.

- [ ] **Step 3: Implement reveal and scrollspy**

Use IntersectionObserver for one-time reveals and active section updates. When reduced motion is enabled or IntersectionObserver is unavailable, reveal everything immediately.

- [ ] **Step 4: Run structural and syntax validation**

Run: `python3 -m unittest tests/test_portfolio.py -v && node --check assets/js/main.js`

Expected: all tests pass and Node reports no syntax errors.

- [ ] **Step 5: Commit interactions**

```bash
git add assets/js/main.js
git commit -m "feat: add portfolio theme and motion interactions"
```

### Task 5: Browser QA, polish, and production deployment

**Files:**
- Modify if needed: `index.html`
- Modify if needed: `assets/css/main.css`
- Modify if needed: `assets/js/main.js`
- Create: `.playwright-mcp/portfolio-desktop-final.png`
- Create: `.playwright-mcp/portfolio-mobile-final.png`

**Interfaces:**
- Consumes: the complete static page.
- Produces: visual evidence, final validation results, and the deployed GitHub Pages revision.

- [ ] **Step 1: Serve the site locally**

Run: `python3 -m http.server 4173`

Expected: `http://127.0.0.1:4173/` returns the redesigned page.

- [ ] **Step 2: Verify desktop and mobile with Playwright**

At 1440×1100 and 390×844, check the hero, navigation, product sections, timeline, theme toggle, mobile menu, contact links, absence of horizontal overflow, and console errors. Capture full-page screenshots.

- [ ] **Step 3: Verify reduced motion and keyboard flow**

Emulate reduced motion, confirm content stays visible and animations are disabled, then tab through skip link, navigation, theme control, project links, and contact actions with visible focus.

- [ ] **Step 4: Run final local gates**

Run: `python3 -m unittest tests/test_portfolio.py -v && node --check assets/js/main.js && git diff --check`

Expected: all tests pass, syntax is valid, and no diff whitespace errors exist.

- [ ] **Step 5: Commit QA fixes**

```bash
git add index.html assets/css/main.css assets/js/main.js
git commit -m "fix: polish responsive portfolio presentation"
```

- [ ] **Step 6: Recheck deployment target and push**

Run: `git status --short --branch && git remote -v && git log -1 --oneline && git push origin main`

Expected: local `main` pushes successfully to the configured GitHub remote. Do not include unrelated untracked screenshot or local-tool files in commits.

- [ ] **Step 7: Verify GitHub Pages**

Open `https://terzigolu.github.io/portfolio/` after the Pages build completes. Confirm the deployed revision shows the new header/hero, loads CSS/JS without 404s, and has no console errors. If deployment fails, inspect the repository's Pages workflow/status before making changes.

