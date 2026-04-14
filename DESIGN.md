# Design System Strategy: Electric Nocturne
 
## 1. Overview & Creative North Star
The dark mode expansion of this design system is defined by the Creative North Star: **"Electric Nocturne."** 
 
We are moving away from the "utility-first" dark mode—which often feels like a desaturated version of light mode—and toward a high-end editorial experience. By utilizing deep, velvet purples and vibrant, neon-infused pinks, we create an environment that feels immersive and premium. 
 
This system breaks the traditional "box-and-grid" template through **Intentional Asymmetry** and **Tonal Depth**. Elements should feel like they are floating in a liquid space rather than being locked into a rigid table. We embrace overlapping typography and soft, organic layering to maintain a "playful" soul within a sophisticated, dark-mode architecture.
 
## 2. Colors: The Depth of Violet
The palette is built on a foundation of deep purples (`#150629`) that act as a canvas for the "Signature Pink" (`#ff8aa7`) to vibrate against. 
 
### The "No-Line" Rule
To achieve a bespoke, premium feel, **1px solid borders are strictly prohibited for sectioning.** Boundaries must be defined through:
*   **Tonal Shifts:** Placing a `surface-container-high` (`#291543`) element against a `surface` (`#150629`) background.
*   **Luminance Stepping:** Using the `surface-container` tiers to dictate priority.
 
### Surface Hierarchy & Nesting
Treat the UI as a physical stack of semi-translucent materials.
*   **Base:** `surface` (#150629) is the ground floor.
*   **Sections:** Use `surface-container-low` (#1b0a31) for large layout blocks.
*   **Interactive Cards:** Use `surface-container-highest` (#301a4d) to pull content toward the user.
 
### The "Glass & Gradient" Rule
Standard flat colors lack the "soul" required for a vibrant identity. 
*   **Signature Textures:** Use subtle linear gradients for primary CTAs, transitioning from `primary` (#ff8aa7) to `primary-container` (#ff7198).
*   **Glassmorphism:** For floating headers or navigation bars, use `surface_bright` (#372056) at 60% opacity with a `20px` backdrop-blur. This allows the background purples to bleed through, creating a "frosted sugar" effect.
 
## 3. Typography: Editorial Rhythm
We utilize **Plus Jakarta Sans** to bridge the gap between playful roundness and professional clarity. 
 
*   **Display Scale:** `display-lg` (3.5rem) should be used with tight letter-spacing (-0.02em) to create a bold, "poster" look.
*   **The Narrative Hierarchy:** Use `headline-lg` (2rem) in `primary` pink to draw the eye to key value propositions.
*   **Body Content:** `body-lg` (1rem) uses `on-surface` (#efdfff) for maximum readability against the dark background.
*   **Labeling:** `label-md` and `label-sm` should be used sparingly in `on-surface-variant` (#b7a3cf) to provide metadata without cluttering the visual field.
 
## 4. Elevation & Depth: Tonal Layering
In this design system, height is expressed through light and color, not shadows and lines.
 
*   **The Layering Principle:** Place `surface-container-lowest` (#000000) cards inside a `surface-container-low` (#1b0a31) section to create a "recessed" look, or vice versa to create "lift."
*   **Ambient Shadows:** If an element must float (like a Modal or Fab), use a shadow with a `40px` blur and `6%` opacity. The shadow color must be sampled from `surface-container-highest`—never pure black—to ensure it feels like a natural glow rather than a muddy drop shadow.
*   **The "Ghost Border" Fallback:** If accessibility requires a container edge, use the `outline-variant` (#514166) at **15% opacity**. It should be felt, not seen.
 
## 5. Components: Fluidity & Roundness
 
### Buttons
*   **Primary:** Full roundness (`9999px`). Background: Gradient of `primary` to `primary-container`. Text: `on-primary` (#620029).
*   **Secondary:** `secondary-container` (#721199) with `on-secondary-container` (#f0bfff) text. No border.
*   **Tertiary:** Transparent background with `primary` text. Use for low-emphasis actions.
 
### Cards & Lists
*   **The Divider Ban:** Strictly forbid 1px lines between list items. Use `8px` of vertical whitespace or alternating tonal shifts (e.g., subtle shifts between `surface-container` and `surface-container-high`).
*   **Rounding:** All cards must use `xl` (3rem) or `full` (9999px) corner radii to maintain the playful, "candy-like" feel.
 
### Input Fields
*   **Styling:** Fields should be styled as `surface-container-highest` with a `full` roundness.
*   **Focus State:** Instead of a thick border, use a `primary` outer glow (4px spread, low opacity) to signify activity.
 
### Chips & Tags
*   Use `secondary-container` for active states and `surface-variant` for inactive states. Always `full` roundness.
 
## 6. Do’s and Don’ts
 
### Do:
*   **Do** use asymmetrical layouts where one column is significantly wider than the other to create an editorial feel.
*   **Do** lean into the "Signature Pink" for micro-interactions (hover states, toggles, loading bars).
*   **Do** use large amounts of negative space to let the deep purples "breathe."
 
### Don’t:
*   **Don't** use pure white (#FFFFFF) for body text; it is too jarring. Use `on-surface` (#efdfff).
*   **Don't** use sharp corners (0px) or standard "Material" roundness (4px). Stick to the provided `md`, `lg`, and `full` scales.
*   **Don't** use standard grey shadows. All depth must be achieved through purple-tinted shadows or tonal layering.
*   **Don't** use dividers to separate content. Let the hierarchy of the typography and background tones do the work.