---
name: Penny
colors:
  surface: '#f9f9ff'
  surface-dim: '#d3daea'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eefe'
  surface-container-high: '#e2e8f8'
  surface-container-highest: '#dce2f3'
  on-surface: '#151c27'
  on-surface-variant: '#3d4a42'
  inverse-surface: '#2a313d'
  inverse-on-surface: '#ebf1ff'
  outline: '#6d7a72'
  outline-variant: '#bccac0'
  surface-tint: '#006c4a'
  primary: '#006948'
  on-primary: '#ffffff'
  primary-container: '#00855d'
  on-primary-container: '#f5fff7'
  inverse-primary: '#68dba9'
  secondary: '#9d4300'
  on-secondary: '#ffffff'
  secondary-container: '#fd761a'
  on-secondary-container: '#5c2400'
  tertiary: '#735c00'
  on-tertiary: '#ffffff'
  tertiary-container: '#cda721'
  on-tertiary-container: '#4e3e00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#85f8c4'
  primary-fixed-dim: '#68dba9'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#005137'
  secondary-fixed: '#ffdbca'
  secondary-fixed-dim: '#ffb690'
  on-secondary-fixed: '#341100'
  on-secondary-fixed-variant: '#783200'
  tertiary-fixed: '#ffe086'
  tertiary-fixed-dim: '#eac33e'
  on-tertiary-fixed: '#231b00'
  on-tertiary-fixed-variant: '#574500'
  background: '#f9f9ff'
  on-background: '#151c27'
  surface-variant: '#dce2f3'
typography:
  headline-lg:
    fontFamily: Manrope
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Manrope
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Manrope
    fontSize: 10px
    fontWeight: '500'
    lineHeight: 12px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin: 20px
---

## Brand & Style

The design system is crafted for a premium personal finance experience that balances professional reliability with an approachable, modern aesthetic. It focuses on a **Minimalist** and **Corporate Modern** style, utilizing heavy whitespace and high-contrast accessibility to reduce the cognitive load of financial management. 

The emotional response should be one of "controlled growth" and "financial clarity." This is achieved through a clean, systematic UI that avoids unnecessary ornamentation, relying instead on precise typography, subtle glassmorphic touches, and a sophisticated color palette to guide the user’s eye toward actionable insights.

## Colors

The palette is centered around a deep emerald primary, symbolizing growth and stability. High-contrast accessibility is a priority, ensuring all interactive elements meet WCAG AA standards.

- **Primary (Emerald):** Used for primary actions, success states, and brand presence.
- **Secondary (Coral):** Reserved for warnings, debt indicators, or urgent notifications.
- **Tertiary (Amber):** Used sparingly for highlights, premium features, or "waiting" states.
- **Neutrals:** Grays are infused with sage undertones (#6B7280) to maintain a cohesive organic feel with the emerald primary.
- **Dark Mode:** Transitions to a deep charcoal base (#1F2937). Surfaces use a lighter charcoal (#374151) to create depth without relying on pure blacks.

## Typography

The design system utilizes **Manrope** for its modern, geometric construction and excellent legibility in data-heavy environments. 

Headlines use a bold weight with slightly tighter letter spacing to create a distinctive, editorial look. Body text is optimized for readability with generous line heights. Labels are utilized for metadata, micro-copy, and chart annotations, often appearing in semi-bold to maintain hierarchy at smaller scales. For mobile views, `headline-lg` should scale down to 24px to ensure headers do not wrap excessively.

## Layout & Spacing

This design system uses a **Fluid Grid** model based on a 4px baseline shift. 

- **Mobile:** 4-column grid with 16px gutters and 20px side margins.
- **Tablet/Desktop:** 12-column grid with 24px gutters. Max content width is capped at 1200px to maintain readability.

Whitespace should be used generously to separate financial categories. Group related items (like transaction lists) using `sm` spacing, while separating major sections (like "Net Worth" vs "Recent Activity") using `xl` spacing.

## Elevation & Depth

Hierarchy is established through **Tonal Layers** and **Ambient Shadows**.

- **Light Mode:** Uses ultra-soft, diffused shadows with a slight emerald tint (Primary Color at 5% opacity) to ground elements. Elevation 2 is used for standard cards; Elevation 4 is reserved for Floating Action Buttons (FAB) and active modals.
- **Dark Mode:** Shadows are largely replaced by "Inner Glows" (1px subtle top border) and distinct surface tonal shifts. The background is `#1F2937`, while elevated cards sit on `#374151`.
- **Glassmorphism:** Apply a 12px backdrop blur to navigation bars and overlay panels to maintain a sense of context and depth.

## Shapes

The shape language is friendly yet structured. The core radius for cards and major containers is **16px** (rounded-lg). Small components like buttons and input fields follow an **8px** radius (standard). 

Floating Action Buttons and Segmented Controls utilize a **Pill-shaped** (full-round) radius to distinguish them as high-priority interactive elements.

## Components

- **Buttons:** Primary buttons use a solid Emerald fill with white text. Secondary buttons use a ghost style with an Emerald border.
- **Cards:** 16px corner radius. In light mode, use a 1px border (#E5E7EB) + Elevation 2. In dark mode, remove shadow and use surface color #374151.
- **Floating Action Button (FAB):** Always circular, Primary Emerald fill, Elevation 4. Positioned bottom-right with 24px padding from edges.
- **Segmented Controls:** Used for toggling views (e.g., Weekly/Monthly). Uses a "pill" container with a sliding background highlight that follows the active segment.
- **Toggle Switches:** Use a soft-track design. When "on," the track is Primary Emerald. When "off," it is Sage Gray.
- **Input Fields:** 8px radius. Active state is indicated by a 2px Emerald border and a subtle glow.
- **Sliders:** Emerald track with a white thumb. Include tick markers for budget thresholds, which turn Coral if the slider exceeds a set limit.
- **Lists:** Transaction items should have a 56px height with 16px horizontal padding, using subtle dividers or clear vertical spacing instead of heavy borders.