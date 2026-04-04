<!-- 
Sync Impact Report:
- Version change: N/A → 1.0.0
- List of modified principles: All (I. Scientific Honesty, II. Privacy by Default, III. Design, IV. Open Source, V. Community, VI. Scope Discipline)
- Added sections: Target User, Problem Statement, MVP Scope, Success Criteria, Non-Negotiables, Revenue Model, V2 Pipeline
- Removed sections: N/A
- Templates requiring updates: 
  - .specify/templates/plan-template.md (✅ updated)
  - .specify/templates/spec-template.md (✅ updated)
  - .specify/templates/tasks-template.md (✅ updated)
- Follow-up TODOs: None
-->

# Hebbo - Brain Training App Constitution

## Core Principles

### I. Scientific Honesty (NON-NEGOTIABLE)
Every game included must have independent, peer-reviewed, third-party evidence for cognitive transfer before it ships. No feature, copy, or marketing claim may overstate what the science supports. If the evidence is contested, that contestation must be acknowledged — not hidden.

### II. Privacy by Default (NON-NEGOTIABLE)
The app functions fully offline. No data leaves the device unless the user explicitly and actively chooses it — not via buried terms of service, but via a clear, plain-language opt-in. Network access is never required to use core features.

### III. Design is a First-Class Requirement
Retention and delight are product goals, not afterthoughts. If the app feels like a medical tool or a research instrument, it has failed its primary user. Cognitive training must feel worth returning to.

### IV. Open Source as Strategic Moat
The codebase is open source from day one — not planned to be open sourced later. Transparency is the primary differentiator against incumbents whose scientific claims are unauditable. The methodology must always be inspectable by researchers, developers, and users.

### V. Community Over Control
The game library is designed to grow through external developer contributions, not solely through internal development. The codebase must be modular enough that a new game can be added without touching core logic. Contribution guidelines ship before V2.

### VI. Scope Discipline
MVP ships three games and nothing else. Every proposed feature gets tested against this constitution before entering the spec. If it cannot be justified here, it does not get built.

## Target User
**Primary (MVP):** Adults aged 25–35 actively optimizing their cognitive performance. Already comfortable with self-improvement tools. Skeptical of pseudoscience. Will pay for quality but not for vague promises.

**Explicitly out of scope for MVP:**
- Children
- Elderly users
- Clinical or diagnostic populations
- Users seeking medical assessment or treatment tools

## Problem Statement
Existing brain training apps are either scientifically dishonest (Lumosity), expensive and closed (Elevate), or clinically credible but designed like medical software from 2009 (BrainHQ). No option exists that is simultaneously honest, beautiful, open, and built to respect user privacy by default. This product fills that gap.

## MVP Scope

### In Scope
- Three mini games: Flanker, Task Switching, Spatial Span
- Local-first, offline-first architecture
- Adaptive difficulty: calibration phase → training zone → mastery signals
- On-device personal progress tracking
- Open source codebase, publicly hosted from day one
- Documented game interface standard (enables future contributions)

### Explicitly Out of Scope for MVP
- User accounts or authentication of any kind
- Server-side data storage
- Research data collection or opt-in data sharing
- Social, multiplayer, or competitive features
- More than three games
- Mental Rotation (deferred to V2)
- Dual N-Back (deferred to V2)
- Support for children, elderly, or clinical populations
- Any health, medical, or diagnostic framing or claims
- Contribution submission infrastructure (documentation only at MVP)

## Success Criteria

1. A user can install the app and complete a full session of all three games without friction or confusion
2. Difficulty adapts visibly and correctly to user performance within three sessions
3. A returning user can see measurable personal progress over time, stored on-device
4. An external developer can read the contribution documentation and understand how to submit a new game without direct help from the core team
5. No scientific claim anywhere in the product is unsupported by cited, independent, peer-reviewed research

## Non-Negotiables

- No health, medical, or diagnostic claims anywhere in the product without formal regulatory review — this includes marketing copy, onboarding, and in-game messaging
- No data collection without explicit active user consent
- Every shipped game must have peer-reviewed independent evidence for cognitive transfer
- The codebase is open source from day one
- The app must function fully and completely offline — always

## Revenue Model

Open core. The base app and all MVP games are free and open source. A premium tier adds advanced features, additional games, and deeper on-device statistics.

Future revenue paths (out of scope for MVP, must not influence MVP decisions):
- Institutional licensing: clinics, schools, corporate wellness programs
- Research data licensing: contingent on building an opted-in user base first

## V2 Pipeline
*(Noted for continuity — must not influence MVP scope or architecture)*

- Mental Rotation
- Dual N-Back
- Opt-in anonymized research data contribution
- Additional age group support (50+ cognitive maintenance)
- External game contribution submission infrastructure

## Governance
This constitution supersedes all other product, design, and technical decisions. Any proposed feature, architectural choice, or copy change that contradicts this document requires a formal constitution update before proceeding — not a silent workaround.

Amendments require:
- A documented reason for the change
- Explicit confirmation before the change is applied
- A downstream scan of spec.md and plan.md for conflicts
- A logged record of what changed and why

**Version**: 1.0.0 | **Ratified**: 2026-04-04 | **Last Amended**: 2026-04-04
