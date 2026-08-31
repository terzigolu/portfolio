---
name: Monochrome Systems Architect
description: Visual identity for Yusuf Terzioglu's product and engineering portfolio.
colors:
  background:
    dark: "#0a0a0a"
    light: "#ffffff"
  foreground:
    dark: "#f5f5f5"
    light: "#171717"
  surface:
    dark: "#121212"
    light: "#ffffff"
  muted:
    dark: "#1f1f1f"
    light: "#fafafa"
  mutedForeground:
    dark: "#a3a3a3"
    light: "#737373"
  border:
    dark: "#2a2a2a"
    light: "#e5e5e5"
  primary:
    dark: "#f5f5f5"
    light: "#262626"
typography:
  display: "Outfit, sans-serif"
  body: "Inter, sans-serif"
  utility: "Geist Mono, monospace"
  bodyLineHeight: 1.65
  readingMeasure: "68ch"
rounded:
  control: "10px"
  card: "16px"
  pill: "999px"
spacing:
  base: "8px"
  section: "clamp(80px, 11vw, 152px)"
  gutter: "clamp(20px, 4vw, 48px)"
components:
  button: "High-contrast filled or quiet bordered control with a 44px minimum target."
  card: "Neutral surface, one-pixel semantic border, no decorative gradient."
  nav: "Sticky horizontal labels on desktop and an accessible disclosure on mobile."
  proof: "Grounded facts shown as stable text; never animated counters."
  timeline: "Single chronological rail with dates in utility typography."
---

# Overview

This portfolio should feel like the workbench of an AI systems architect: precise, calm, readable, and opinionated. Its single job is to establish Yusuf Terzioglu's technical point of view through real products and experience, then make his work and contact details easy to reach.

The signature device is a continuous system trace connecting **Architect**, **Build**, and **Operate**. It may animate once as the page is revealed, but it must remain structural rather than decorative.

## Typography

- Use Outfit for large display statements and section headings.
- Use Inter for paragraphs, controls, and navigation.
- Use Geist Mono only for dates, metrics, short labels, and technical annotations.
- Keep paragraphs near 68 characters per line and use a minimum 1.6 line height.
- Never set long paragraphs or the entire interface in monospace.

## Color and Surfaces

- Dark mode is the default and uses true neutral black rather than a blue tint.
- Light mode is pure white with neutral gray borders and text.
- Use borders and spacing to establish hierarchy before adding shadow.
- Decorative color accents, violet/cyan glow, glassmorphism, and gradient meshes are not part of this identity.

## Layout and Motion

- Use a centered maximum-width content rail with asymmetric compositions for featured products.
- Treat mobile as its own composition and verify down to 320px.
- Use one orchestrated hero entrance, one-time scroll reveals, and quiet hover transitions.
- Respect `prefers-reduced-motion`; content must stay visible without JavaScript.

## Do

- Lead with Yusuf's name, technical thesis, and selected work.
- Use verified content already present in the portfolio.
- Give ORKAI and Ramorie more visual weight than supporting work.
- Use visible focus states, semantic landmarks, and labeled controls.
- Reserve space for images to prevent layout shift.

## Don't

- Do not invent product metrics, customers, testimonials, or production impact.
- Do not use skill percentage bars or animated counters.
- Do not use a looping typewriter, particle field, 3D scene, or ambient gradient blob.
- Do not turn the portfolio into a dashboard or generic bento grid.
- Do not hide navigation meaning behind unlabeled icons.
