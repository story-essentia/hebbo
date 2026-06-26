# Hebbo 🧠⚡

Hebbo is a science-backed cognitive training application built with Flutter. It is designed to strengthen core executive functions—such as cognitive control, working memory, attention, and mental flexibility—through highly polished, gamified exercises.

---

## 🏛️ Tribute to Donald Hebb

The application is named **Hebbo** as a tribute to **Donald O. Hebb** (1904–1985), the legendary father of neuropsychology. 

Hebb's pioneering work in the mid-20th century revolutionized how we understand the brain's adaptation and learning processes. His famous postulate—often summarized as **"cells that fire together wire together"**—laid the foundation for modern neuroscience, artificial neural networks, and the study of synaptic plasticity. 

Hebbo serves as a practical, modern homage to Hebbian learning: by engaging in focused cognitive exercises, users stimulate and strengthen the neural pathways responsible for attention, working memory, and cognitive flexibility.

---

## 🎮 Cognitive Training Suite

Hebbo features three primary exercises designed around classic paradigms from neuropsychological literature:

### 1. Flanker Task (Attention & Inhibition)
* **Goal**: Focus on a central target stimulus and indicate its direction while actively suppressing distracting "flankers" surrounding it.
* **Cognitive Focus**: Selective attention, interference control, and conflict resolution.
* **Environment**: *Shallow Reef / Open Ocean / Deep Sea* animated aquatic backgrounds that transition as difficulty shifts.

### 2. Task Switching (Cognitive Flexibility)
* **Goal**: Rapidly alternate between categorizing stimuli based on different rules (e.g., color vs. shape, or parity vs. size) under time pressure.
* **Cognitive Focus**: Goal-shifting, rule retrieval, and reducing cognitive switch cost.
* **Environment**: Clean particle effects reacting to correctness, featuring a glowing Neon Orb.

### 3. Spatial Span (Visual-Spatial Working Memory)
* **Goal**: Observe a sequence of glowing shards lighting up in a grid, then recall and replicate the sequence in order (forward or backward).
* **Cognitive Focus**: Visual-spatial storage, mental imagery, and working memory capacity.
* **Environment**: *Cosmic Spacetime* parallax backgrounds with star trails and neon perspectives.

---

## 🌌 Visual Design: "Electric Nocturne"

Hebbo breaks away from typical "utility-first" dark modes. It is built under the creative direction of **"Electric Nocturne"**—a premium, editorial aesthetic:

* **Tonal Depth**: Grounded in deep velvet purples (`#150629`) acting as a fluid canvas for vibrant, neon-infused pinks (`#FF8AA7`) to pop against.
* **No-Line Rule**: Section boundaries and cards are defined using tonal shifts (e.g., `#301A4D`) and organic layering instead of rigid 1px solid borders.
* **Typography**: Features **Plus Jakarta Sans** for a premium balance between editorial roundness and modern legibility.
* **Micro-Animations**: Uses custom canvas painters, parallax scrolling, custom particle engines, and fluid transitioners that make the interface feel responsive and alive.

---

## 🛠️ Technology Stack

* **Framework**: Flutter (Multi-platform mobile & desktop support)
* **State Management**: Flutter Riverpod & Riverpod Generators
* **Local Database**: Drift (SQLite) for high-performance session, trial, and difficulty history tracking
* **Persistence**: SharedPreferences for user preferences and setup states
* **Icons & Assets**: Custom adaptive launcher icons generated using `flutter_launcher_icons`

---

## 🚀 Getting Started

### Prerequisites
Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured on your system.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/hebbo.git
   cd hebbo
   ```

2. Fetch the dependencies:
   ```bash
   flutter pub get
   ```

3. Generate launcher icons (if modifying design assets):
   ```bash
   dart run flutter_launcher_icons
   ```

4. Run the app in debug mode on a connected device:
   ```bash
   flutter run
   ```

5. Build the production Android App Bundle:
   ```bash
   flutter build appbundle --release
   ```
