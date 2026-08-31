# Monochrome Portfolio Redesign

## Purpose

Redesign Yusuf Terzioglu's portfolio so it presents him as an experienced AI systems architect and product builder, not as a customized Bootstrap resume template. The page must feel visually related to Ramorie without copying an application dashboard into a personal site.

The page has one primary job: establish Yusuf's technical point of view through concrete products and experience, then make it easy to inspect his work or contact him.

## Source Material

- Preserve the verified claims already present in `index.html`, including 10+ years of engineering, 7+ years of React Native, and systems processing 500K+ social-media comments.
- Preserve the existing ORKAI, Ramorie, and SentScan descriptions and outbound links.
- Preserve education, experience, contact details, social links, metadata, structured data, `robots.txt`, and `sitemap.xml` unless a presentation change requires reorganizing them.
- Use Ramorie Frontend's neutral shadcn token model as the color reference: pure white light surfaces, true neutral dark surfaces, fine borders, quiet muted text, and controlled radii.
- Do not introduce new achievements, customers, usage numbers, or production claims.

## Creative Direction

### Name

**Monochrome Systems Architect**

### Thesis

The site should read like the workbench of someone who builds durable AI products: precise, calm, technical, and opinionated. The memorable element is a continuous **system trace** that begins in the hero and reappears as a structural line through featured work and experience. It represents the path from idea to production system without turning the page into a terminal imitation.

### Design Principles

- Typography carries the personality; gradients and glow effects do not.
- Borders and contrast establish hierarchy; excessive shadows do not.
- Large product stories replace a generic grid of equal cards.
- Motion reveals relationships and state changes; it does not continuously distract.
- Monospace is reserved for labels, metrics, dates, and technical metadata.
- Mobile is a first-class composition, not a collapsed desktop layout.

## Design Tokens

The implementation will define semantic CSS custom properties and consume those properties everywhere.

### Color

Dark mode is the default visual presentation. Light mode follows the same semantic tokens and can be selected explicitly.

| Token | Dark | Light | Use |
| --- | --- | --- | --- |
| `--background` | `#0a0a0a` | `#ffffff` | Page canvas |
| `--foreground` | `#f5f5f5` | `#171717` | Primary text |
| `--surface` | `#121212` | `#ffffff` | Raised sections and cards |
| `--muted` | `#1f1f1f` | `#fafafa` | Quiet fills |
| `--muted-foreground` | `#a3a3a3` | `#737373` | Secondary text |
| `--border` | `#2a2a2a` | `#e5e5e5` | Dividers and controls |
| `--primary` | `#f5f5f5` | `#262626` | Primary action |
| `--primary-foreground` | `#0a0a0a` | `#ffffff` | Primary action text |

Status colors may remain semantic where accessibility requires them, but decorative color accents, violet glows, cyan glows, and tinted glass surfaces are removed.

### Typography

- Display/headings: **Outfit**, 600-700 weight, tight tracking. Its geometric shapes give the hero an authored identity while remaining readable.
- Body/interface: **Inter**, 400-600 weight, normal tracking, 1.6-1.75 line height for long copy.
- Technical utility: **Geist Mono**, 400-600 weight, used only for labels, dates, metrics, and small annotations.
- Body copy should generally remain between 16px and 20px. No paragraph may be set entirely in monospace.
- Line length is capped near 68 characters for long-form copy.

### Shape and Spacing

- Base radius: 10px; larger product frames may use 16px.
- Fine 1px borders are the default separation device.
- Page content uses a maximum width near 1200px and a consistent responsive gutter.
- Section spacing uses a restrained scale based on 8px increments, with generous vertical whitespace rather than empty full-screen gaps.

## Information Architecture

### 1. Sticky Header

- Compact wordmark: `YT / Systems Architect`.
- Text navigation: Work, About, Experience, Contact.
- Controls: theme toggle and a visible `Let's talk` action.
- Desktop uses a centered horizontal bar. Mobile uses an accessible disclosure menu.
- Scrollspy updates the active section without hiding labels behind icons.

### 2. Hero

- Primary headline: Yusuf Terzioglu's name plus a direct statement about building AI products and systems that survive production.
- Supporting paragraph uses the current verified domains: AI SaaS, LLM orchestration, full-stack web/mobile, and autonomous agent systems.
- Primary action jumps to featured work; secondary action opens email.
- A compact availability/location line replaces the current personal-data list.
- The system trace appears as an animated path with three verified stages: `Architect`, `Build`, `Operate`.
- No typing loop. The hero should be understandable immediately and remain stable for assistive technology.

### 3. Proof Strip

A horizontal set of grounded facts:

- 10+ years engineering
- 7+ years React Native
- 500K+ comments processed by production systems
- Istanbul, Turkey

These are facts already present in the current site, not counters that animate from zero.

### 4. Featured Work

- ORKAI and Ramorie receive large alternating case-study compositions with existing product screenshots.
- SentScan is shown as a smaller supporting product story if its current content and asset quality support it.
- Each product story includes: problem, system contribution, selected technologies, and existing external link when available.
- Screenshots are framed with neutral surfaces and fine borders; hover motion is limited to a small elevation or image shift.
- The section must not imply confidential customers, revenue, or usage beyond existing verified copy.

### 5. About and Principles

- Use Yusuf's portrait in monochrome or naturally muted treatment.
- Replace the duplicated biography with one concise narrative.
- Present the existing principle — simplicity, determinism, observability — as a typographic manifesto.
- Contact details are reduced to relevant professional information; phone remains available in the contact section rather than dominating the biography.

### 6. Capabilities

- Replace subjective percentage progress bars with grouped capabilities.
- Groups: AI systems, product engineering, mobile, backend/infrastructure, and IoT/embedded.
- Each group uses concise chips or rows for technologies already listed in the current site.
- The hierarchy communicates breadth and depth without pretending that skill can be measured as an exact percentage.

### 7. Experience

- Use a single readable timeline ordered by recency.
- Current/recent architecture and product-building work appears first.
- Earlier career remains available but visually quieter.
- Education is a compact companion block rather than a competing timeline.
- Keep dates and company/role content from the current page; only presentation and duplicated prose change.

### 8. Contact and Footer

- Finish with a high-contrast invitation to discuss AI systems, product architecture, or mobile engineering.
- Provide email, LinkedIn, and GitHub as explicit labeled actions.
- Preserve footer copyright and remove template credits if licensing permits; otherwise retain required attribution in a quiet legal line.

## Motion System

- Page load: one orchestrated hero sequence, approximately 700-900ms total.
- Scroll reveal: native IntersectionObserver adds a small opacity/translate transition once per element.
- System trace: line drawing occurs once when visible; it must not loop indefinitely.
- Product hover: 150-220ms transform and border transition.
- Theme change: short color/background transition with no full-page flash.
- Navigation: smooth anchor scrolling with sticky-header offset.
- `prefers-reduced-motion: reduce` disables transforms, line drawing, smooth scrolling, and nonessential animation.
- Content remains visible when JavaScript is disabled; reveal styles only activate after a JS-ready class is applied.

## Technical Approach

The site remains a static GitHub Pages-compatible implementation. A framework migration is out of scope because it would add build and deployment complexity without improving the single-page portfolio experience.

Primary files:

- `index.html`: restructure semantic sections, navigation, content hierarchy, theme control, and accessible labels.
- `assets/css/main.css`: replace template styling with the tokenized responsive design system.
- `assets/js/main.js`: replace template-specific behaviors with mobile navigation, theme persistence, scrollspy, reveal orchestration, and reduced-motion-aware interactions.
- `DESIGN.md`: add the concise project-level token and component contract required for future UI changes.

Existing vendor files can remain on disk for compatibility, but unused libraries should no longer be loaded by `index.html`. The redesign should avoid depending on Bootstrap layout, AOS, Typed.js, PureCounter, Waypoints, Isotope, GLightbox, or Swiper unless a real surviving interaction requires one.

## Accessibility and Performance

- Semantic landmark structure and heading order.
- Skip link, visible keyboard focus, correctly labeled controls, and no icon-only navigation without accessible names.
- Minimum WCAG AA text contrast in both themes.
- Touch targets at least 44px where practical.
- Images receive useful alt text, explicit dimensions or aspect-ratio reservation, lazy loading below the fold, and async decoding.
- No autoplay video or infinite ambient animation.
- The primary content and navigation work without JavaScript.
- Target no unexpected layout shift and keep the initial page usable before remote fonts finish loading.

## Responsive Behavior

- Mobile: single-column hero, proof facts in a two-column grid, product stories stacked, compact timeline, disclosure navigation.
- Tablet: balanced two-column sections where content length supports it.
- Desktop: asymmetrical hero, alternating case studies, and a readable centered content rail.
- No horizontal overflow at 320px viewport width.

## Verification

- Validate semantic HTML and inspect the browser console for errors.
- Verify at representative widths: 1440px, 1024px, 768px, 390px, and 320px.
- Verify dark and light themes, including persisted selection and system preference fallback.
- Verify keyboard navigation, mobile menu, anchor scrolling, active navigation, mail/social links, and reduced-motion behavior.
- Capture full-page desktop and mobile screenshots for visual critique.
- Recheck metadata, JSON-LD, canonical URL, robots, and sitemap after restructuring.

## Explicit Non-Goals

- No CMS, contact backend, analytics integration, or framework migration.
- No invented product metrics, testimonials, client logos, or case-study outcomes.
- No decorative 3D scene, particle background, gradient mesh, terminal typing loop, or generic bento-dashboard layout.
- No removal of valid resume history merely to make the page shorter; older history may be visually condensed.

