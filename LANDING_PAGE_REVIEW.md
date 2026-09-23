# Landing page content review

Updated 23 September 2026 after the design correction.

## Design and structure
`index.html` now uses `index - Copy.html` as its visual base. The reference file is unchanged. Preserved the violet/pink/yellow palette, gradient hero, floating dashboard cards, rounded navigation, typography, sticky walkthrough, dark AI section, animated platform orbit, audience tabs, and oversized closing wordmark.

Condensed the original page to seven sections: hero, three-step product workflow, creative AI, platform connections, teams/agencies, FAQ, and closing CTA. Removed repeated statistics, before/after comparison, dashboard reveals, feature grids, optimization timelines, and unsupported case studies. Footer links now point to real page sections or the observed app entry points.

## Content evidence and limits
- Public onboarding describes website-based brand profile, ad copy and imagery generation, plus manual setup.
- The visible creative studio describes prompt-based image generation, optional references and an asset library.
- Visible campaign navigation includes status, date filters and budgets. Connections UI lists platform integrations and account health.
- Further private tenant research was blocked in the earlier review pending authorization; no additional tenant access occurred during this design correction.
- Detailed automatic optimization, approvals and publishing claims are omitted because those flows were not verified.
- Dashboard numbers, campaign rows and field values are clearly labeled illustrative examples. No private account data appears in the page.

## Implementation and verification
Preserved GSAP, ScrollTrigger and Lenis animations from the reference. Removed animation handlers for deleted sections and the unrelated copied Cloudflare script. Product-step and audience controls work independently of the animation libraries. Added keyboard activation, accessible preview-field labels and reduced-motion handling.

Verified desktop at 1440px and mobile at 390px, workflow selection by click and keyboard, audience switching, mobile menu/Escape, internal anchors and browser console. JavaScript syntax and `git diff --check` pass.

FAQ restored per user reference: four native details accordions with matching rounded cards, violet controls, serif heading and responsive two-column layout. Added desktop/mobile navigation and footer links. Verified click expansion, Enter collapse, and mobile width.

Product use cases now replace the audience tabs with three overlapping sticky cards in the reference violet, yellow and dark colors. Content is grounded in the previously observed onboarding, creative-studio and campaign/connection interfaces; no new private tenant access was made. Removed the sample audience ROAS dashboard. Cards cover brand setup, creative briefs and campaign oversight, with explicit preview labels. Desktop scrolling confirms overlapping sticky positions; reduced-motion and short-height screens use a normal non-sticky layout. FAQ and social icons remain intact.
