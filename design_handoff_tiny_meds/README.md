# Handoff: Tiny Meds — Hi-Fi Designs (8 Core Screens)

## Overview

Tiny Meds is a Flutter Android app for managing a home medicine inventory and creating expiry / low-stock / dose alerts. This bundle contains hi-fi visual designs for the 8 core screens of the app, built directly on the tokens already defined in the Flutter codebase (`lib/core/theme/app_theme.dart`).

Target codebase: https://github.com/urunkarpm/Tiny-Meds (Flutter 3.x, Dart 3, Material 3, Riverpod, Drift).

## About the Design Files

The files in this bundle are **design references created in HTML/React** — prototypes showing intended look, layout, spacing, and behavior. They are **not production code to copy directly**.

The task is to **recreate these designs as Flutter Material 3 widgets** in the existing Tiny-Meds codebase, following the patterns already in `lib/presentation/`. The HTML/React reflects the same `ColorScheme.fromSeed(seedColor: Color(0xFF0A84FF))` and `ThemeData` that `app_theme.dart` already produces — so most of the visual translation is "use the M3 widget that matches what you see in the mockup".

## Fidelity

**High-fidelity.** Final colors, typography, spacing, component sizes, and interaction copy are all decided. The developer should recreate the UI pixel-faithfully using:
- `Theme.of(context).colorScheme` for all colors
- M3 widgets (`FilledButton`, `OutlinedButton`, `TextButton`, `FilterChip`, `Card`, `NavigationBar`, `FloatingActionButton.extended`, `LargeAppBar`, `BottomSheet`, `SegmentedButton`, `Slider`)
- Material 3 type scale (`Theme.of(context).textTheme.headlineMedium`, etc.)
- The existing `AppTheme.getExpiryStatusColor / Icon / Label` helpers — do not re-derive expiry colors

## Design Tokens

All tokens come from `lib/core/theme/app_theme.dart` — already in the codebase. Values listed here for cross-reference only.

### Colors — Light
| Token | Hex |
|---|---|
| `seedColor` / `colorScheme.primary` | `#0A84FF` |
| `colorScheme.surface` | `#F8F9FA` |
| `colorScheme.surfaceContainerHighest` | `#F1F3F5` |
| `surfaceContainerLowest` (cards) | `#FFFFFF` |
| `surfaceContainer` (background-app) | `#ECEFF2` |
| `onSurface` | `#1B1F24` |
| `onSurfaceVariant` | `#5C6470` |
| `outline` | `#C0C6CD` |
| `outlineVariant` | `#E2E5E9` |
| `error` (Expired) | `#BA1A1A` |
| `errorContainer` | `#FFDAD6` |
| Expires today | `#D32F2F` (Colors.red) |
| Expiring soon (≤7d) | `#FF9800` (Amber) |
| Expiring this month (≤30d) | `#FFA726` (Light amber) |
| Active / success | `#1B873B` |

### Colors — Dark
| Token | Hex |
|---|---|
| `surface` | `#121212` |
| `surfaceContainerHighest` | `#2C2C2C` |
| `primary` | `#A8C8FF` |
| `error` | `#FFB4AB` |

### Typography
- Family: **Inter** (in mockup) → use the codebase default (Roboto Flex on Android) unless the team adds a custom font. The M3 type scale is what matters.
- Scale (M3 standard, used throughout):
  - `headlineLarge` 32/600
  - `headlineMedium` 28/600
  - `headlineSmall` 24/600
  - `titleLarge` 22/600
  - `titleMedium` 16/600
  - `titleSmall` 14/600
  - `bodyLarge` 16/400
  - `bodyMedium` 14/400
  - `bodySmall` 12/400
  - `labelLarge` 14/600 +0.1
  - `labelMedium` 12/600 +0.5

### Shape
| Component | Radius |
|---|---|
| Cards | 16dp |
| Input fields | 12dp |
| Chips | 8dp (square-ish, M3 expressive) |
| FAB | 16dp |
| Buttons | full pill (height/2) |
| Bottom sheet top corners | 20dp |
| Phone frame outer | 36dp (preview only) |

### Spacing
4dp base unit. Common values: 4, 8, 12, 16, 20, 24, 32. Screen edge padding: 20dp. List row padding: 14dp vertical / 16dp horizontal.

### Touch targets
48×48dp minimum (already enforced by M3 widgets).

---

## Screens

All 8 screens are at 412×892dp (Pixel reference frame), with M3 status bar (32dp), gesture nav (24dp). When implementing in Flutter, just use `Scaffold` — frame chrome in the mockup is illustrative.

### 01 · Onboarding
- **Purpose**: First-launch welcome; explain the app and start the Add-medicine flow.
- **Layout**: Full-bleed `Scaffold`. Top half: hero illustration — 4 medicine tiles in a 2×2 grid, lightly rotated, with a soft `primaryContainer` radial halo behind. Middle: page indicator (3 dots — first is `24×6` pill in `primary`, others 6×6 in `outline`). Then `headlineLarge` title + `bodyLarge` body, padded 24dp.
- **CTA**: Sticky bottom — full-width `FilledButton` "Get started" (height 48), then `TextButton` "I already have a list to import", then 12dp `bodySmall` privacy note "Stays on your phone. No account needed." in `onSurfaceVariant`.
- **Copy**: Title "Your medicine cabinet, organized." Body "Track every bottle, get a heads-up before things expire, never run out of essentials."

### 02 · Cabinet (home)
- **Purpose**: Main inventory list. Default after onboarding.
- **App bar**: Large M3 app bar — search & bell icons (bell with red badge "2") right; title `headlineMedium` "Cabinet" + `bodyMedium` "22 medicines · 2 need attention".
- **Filter chips row**: horizontal-scroll, 8dp gap, 20dp side padding. Chips: All · 22 (selected), Expiring, Low stock, Expired, By location.
- **Attention card**: full-width 16dp-radius card in `errorContainer`. 40dp circular `error` badge with white warning icon (filled). Title `titleMedium` "2 things need a look", body `bodySmall` "1 expired · 1 running low". Trailing chevron.
- **Section header**: `titleMedium` "Recently added" + `labelMedium` "SORT: NAME" (right, `onSurfaceVariant`).
- **Medicine list**: 16dp-radius cards on `surfaceContainerLowest`, 12dp padding, 8dp gap. Each row = 56dp `MedTile` (form-specific colored gradient + glyph) + name (`titleMedium`) + meta `bodySmall` "{strength} · {qty} {unit} · {location}" + `StatusPill` below.
  - Sample data: Amoxicillin 500mg capsule (Expires in 4 days, fridge), Ibuprofen 200mg tablet (Active, kitchen), Vitamin D3 1000IU tablet (Active, bedside), Cough Syrup 120ml liquid (Low stock, bathroom), Loratadine 10mg tablet (Expired Mar 14, kitchen), Hydrocortisone 1% cream (Active, bathroom).
- **FAB**: extended FAB bottom-right, 56dp tall, label "Add medicine", `primary` bg, plus icon. Bottom 96dp to clear nav bar.
- **NavigationBar** (M3, bottom): Cabinet (active), Alerts, Calendar, Settings.

### 03 · Search & filter
- **Purpose**: Active search with all filter facets visible.
- **Search bar**: Top — 56dp, fully rounded (radius 28), `surfaceContainer` background. Back arrow left, query "ibu|" with primary cursor, close (X) right. 16dp side padding.
- **Filter sections** (each preceded by `titleSmall` label):
  - **Status**: 4 `FilterChip`s — Expired (selected, `error` bg), Expiring soon (selected, `expireSoon` bg), Low stock, Active.
  - **Form**: Tablet, Capsule (selected), Liquid, Cream, Inhaler — each with leading icon (pill / droplet / spray / etc).
  - **Location**: Kitchen drawer, Fridge (selected), Bathroom, Bedside, Travel kit — leading location pin.
  - **Expires within**: M3 `Slider` with active track at ~35%, 24dp thumb with 8dp halo (`primary @ 10%`). Min "Today", max "6 months", current value "~ 7 weeks" shown as `bodySmall`.
- **Sticky footer**: `surface` bg, top divider. `TextButton` "Clear" + flex `FilledButton` "Show 3 results" (height 48). Result count updates live as filters change.

### 04 · Medicine detail (Amoxicillin)
- **App bar**: 56dp top — back, spacer, edit, more.
- **Hero block** (24dp side padding):
  - Row: 88dp `MedTile` (capsule, blue hue) + name `headlineSmall` "Amoxicillin" + `bodyMedium` "500mg · Capsule" + `bodySmall` "by Generic Pharma". `StatusPill` "Expires in 4 days" (kind: soon).
  - Two stat cards (1:1 grid, 12dp gap) on `surfaceContainerLowest`:
    - Quantity: `labelMedium` "QUANTITY" / `headlineMedium` "6" + `bodySmall` "capsules" / 4dp progress bar at 30% in `expireSoon`.
    - Expires: `labelMedium` "EXPIRES" / `headlineMedium` "4" (`expireSoon` color) + `bodySmall` "days · May 7" / `bodySmall` "Opened Apr 22".
- **Details list** (`surfaceContainerLowest` card, 14dp rows separated by `outlineVariant`): Where → Fridge, Opened → Apr 22 2026, Prescribed by → Dr. Singh, Notes → Take with food. Each row: 20dp icon + label + right-aligned value.
- **Alerts attached**: titled card with "+ Add alert" `TextButton`. Two rows: 36dp circular icon badge (filled bell on `primaryContainer` for active) + title + sub + chevron.
- **Sticky footer**: `OutlinedButton` "Take dose" (leading minus icon) | `FilledButton` "Refill" — 1:1, height 48, 12dp gap.

### 05 · Add medicine (step 2 of 4)
- **App bar**: close (X) + title "Add medicine" + `TextButton` "Save".
- **Stepper**: 4 segments, 4dp tall, gap 6dp; first 2 in `primary`, rest in `outlineVariant`. Below: `labelMedium` "STEP 2 OF 4" + `titleLarge` "The basics".
- **Scan card**: Full-width on `primaryContainer`, 16dp radius, 16dp padding. 48dp `primary` icon tile (camera), title `titleMedium` "Scan the box", sub `bodySmall` "We'll fill in name, strength, expiry", trailing chevron.
- **OR divider**: thin lines + `labelMedium` "OR ENTER MANUALLY".
- **Form fields** (M3 outlined text fields, 12dp radius, 56dp tall):
  - Name field — focused state, `primary` border + label, value "Amoxicillin".
  - Strength + Unit row (1.4 : 1) — strength "500", unit dropdown "mg".
- **Form selector** (chips with leading icons): Tablet, Capsule (selected), Liquid, Cream, Inhaler, Other.
- **Quantity stepper**: 44dp circular minus button (outlined) | 56dp center field showing "20 capsules" (`headlineSmall`) | 44dp circular plus button (filled `primary`).
- **Footer**: `OutlinedButton` "Back" | `FilledButton` "Next: Where" (1 : 1.4).

### 06 · Alerts
- **Top**: large app bar — search + more icons; `headlineMedium` "Alerts" + `bodyMedium` "2 today · 3 coming up".
- **Filter chips**: All (selected), Expiry (clock leading), Low stock (inventory leading), Doses (bell leading).
- **TODAY section** (`labelLarge` in `error` color, letter-spacing 1):
  - Expired card: 4dp left border in `error`. 40dp `errorContainer` icon tile with filled warning. Title "Loratadine expired", sub "Expired Mar 14 · Kitchen drawer", right "2h ago". Inline actions: `FilledButton` "Toss & remove" (`error` bg, white fg, height 36) + `TextButton` "Snooze".
  - Low-stock card: 4dp left border in `expireSoon`. Same shape — title "Cough Syrup running low", sub "About 2 doses left · Bathroom". Actions: `FilledButton` "Add to shopping" + `TextButton` "Mark refilled".
- **UPCOMING section** (`labelLarge` in `onSurfaceVariant`): plain-row cards (no left border, no inline actions) — "Amoxicillin expires soon · In 4 days · May 7", "Vitamin D3 · daily · Every day at 9:00 AM", "Ibuprofen expires · In 3 weeks · May 24". Right-aligned `labelMedium` time/date.
- **NavigationBar** active = Alerts.

### 07 · Set up an alert
- **App bar**: back + "New alert" + `TextButton` "Save".
- **FOR section**: med-picker card on `surfaceContainerLowest` — 48dp `MedTile` + title "Amoxicillin 500mg" + sub "Fridge · 6 capsules" + trailing `chevron_down`.
- **TYPE segmented control**: M3 `SegmentedButton` — Expiry (selected, with check icon), Low stock, Dose. Outer radius 24, height 44.
- **HOW EARLY picker**: card containing a 4dp horizontal track with 4 stops at 0 / 0.4 / 0.75 / 1.0 — labels "30 days", "7 days" (selected; 24dp `primary` thumb with 8dp halo, primary label bold), "1 day", "Today". Track is `outlineVariant`; selected portion (0 → selected) in `primary`.
- **TIME OF DAY**: row card, clock icon + "9:00 AM" (`bodyLarge`) + chevron. Tap opens `showTimePicker`.
- **PREVIEW**: notification preview card on `surfaceContainerHigh`, 16dp radius. 36dp `primary` icon tile (filled bell). App name + "now" right. Two lines: "Amoxicillin expires in 7 days" / "Tap to view in cabinet".
- **Footer**: full-width `FilledButton` "Save alert" (height 48).

### 08 · Settings
- **Header**: `headlineMedium` "Settings".
- **You card**: `primaryContainer` bg, 56dp avatar (`primary` bg, white initial "P"), title "Your cabinet", sub "22 medicines · since April 2026", trailing chevron.
- **Notifications group** (card, rows separated by `outlineVariant`):
  - Expiry alerts — toggle ON
  - Low stock alerts — toggle ON
  - Dose reminders — toggle OFF
  - Quiet hours — sub "Mute between 10:00 PM and 7:00 AM", chevron
  - Notification sound — value "Soft chime", chevron
- **Defaults group**: Default lead time → 7 days, Low-stock threshold → 3 doses, Default location → Kitchen.
- **Your data group**: Export as CSV (sub "Download your medicine list"), Medical disclaimer, Reset cabinet (sub "Permanently delete all data" — `error` color text + icon).
- **Footer**: `bodySmall` "Tiny Meds v0.1 · Everything stays on this phone" centered, `onSurfaceVariant`.
- **NavigationBar** active = Settings.

---

## Components (map to Flutter widgets)

| Mockup component | Flutter widget |
|---|---|
| MedTile (form glyph + gradient) | Custom `Container` with `LinearGradient` + a small `CustomPainter` or `SvgPicture` per `MedicineForm` enum |
| StatusPill | Custom `Container` — small dot + label, derive bg/fg from `AppTheme.getExpiryStatusColor` (with low-alpha bg) |
| Filter chip | `FilterChip` (M3) |
| Form/location chip | `FilterChip` with `avatar:` icon |
| Stepper +/- | `IconButton.filled` (plus) + `IconButton.outlined` (minus) |
| Segmented control | `SegmentedButton` |
| Lead-time picker | Custom — `Slider` with discrete divisions=3 + labels under each tick |
| Notification preview | Plain `Card` styled to look like the system notification |
| FAB extended | `FloatingActionButton.extended` |
| Bottom nav | `NavigationBar` |
| Toggles | `Switch` |
| Top app bar | `SliverAppBar.large` (Cabinet, Alerts, Settings) or regular `AppBar` |

## Interactions & Behavior

- **Cabinet → Detail**: tap any list row → `Navigator.push` to detail with the `Medicine` entity.
- **Cabinet → Add**: extended FAB → push a 4-step `PageView` modal (already exists as `add_medicine_bottom_sheet.dart` — adapt to multi-step).
- **Cabinet → Search**: search icon in app bar → push search screen with empty `TextField` autofocused.
- **Search**: every chip / slider change re-runs the query and updates the "Show N results" button live.
- **Detail → Take dose**: decrement quantity by 1 dose, animate the count, evaluate low-stock alerts.
- **Detail → Refill**: open quantity update sheet.
- **Alerts → Toss & remove**: snackbar undo + delete medicine.
- **Set alert → Save**: create `Alert` entity, schedule via `flutter_local_notifications` on the appropriate channel (`expiry_alerts` / `stock_alerts` / `dose_reminders` per the README's notification channels).
- **Settings toggles**: persist to `flutter_secure_storage` + reschedule notifications.

### Motion
- Use M3 standard easing (`Curves.easeOutCubic`) and durations (`200ms` for state, `300ms` for nav, `400ms` for emphasized).
- FAB hides on scroll-down, shows on scroll-up.
- Status pill color transitions on quantity/expiry change.

## State Management

Riverpod providers already exist:
- `inventoryProvider` (in `lib/presentation/providers/inventory_provider.dart`) — list + filters
- `repositoryProviders` — repo wiring

You'll need to add:
- `searchQueryProvider` (StateProvider<String>)
- `filterProvider` (StateNotifierProvider<FilterState>) — selected status / form / location chips, lead-time slider value
- `alertsProvider` for the Alerts screen (separate from `inventoryProvider`, joined by `medicineId`)
- `settingsProvider` for the toggles & defaults

## Assets

No external assets required. Medicine "tiles" are gradient-filled boxes with a small SVG-style glyph per `MedicineForm`. Icons are M3 rounded — use `Icons.*_rounded` (`warning_rounded`, `inventory_2_rounded`, `medication_rounded`, etc.) per the existing `AppTheme.getExpiryStatusIcon`.

## Files

- `Tiny Meds Designs.html` — the live prototype (open in a browser to interact)
- `md-design-system.jsx` — token definitions, atoms (T, Icon, Chip, Card, MedTile, StatusPill, NavBar, AppBar, IconBtn, FAB, Phone)
- `md-screens-1.jsx` — Onboarding, Cabinet, Search, Detail
- `md-screens-2.jsx` — Add, Alerts, Set alert, Settings
- `design-canvas.jsx`, `tweaks-panel.jsx` — preview chrome only, ignore for implementation
- `screenshots/` — PNG of each screen (light mode, green accent, in-frame). Use as the visual reference if you can't run the prototype.

## Screenshots

| # | Screen | File |
|---|---|---|
| 01 | Onboarding | `screenshots/01-onboarding.png` |
| 02 | Cabinet (home) | `screenshots/02-cabinet.png` |
| 03 | Search & filter | `screenshots/03-search.png` |
| 04 | Medicine detail | `screenshots/04-detail.png` |
| 05 | Add medicine (step 2) | `screenshots/05-add-medicine.png` |
| 06 | Alerts | `screenshots/06-alerts.png` |
| 07 | Set up an alert | `screenshots/07-set-up-alert.png` |
| 08 | Settings | `screenshots/08-settings.png` |

The phone frame in each PNG is preview-only — the design is everything inside the bezel. Frames are at the visible viewport (412×892dp); scrollable screens (Detail, Alerts, Add medicine, Set alert, Settings) extend below the fold — open the live prototype to see them in full.

## Notes for the implementer

1. **Don't re-derive expiry colors** — use `AppTheme.getExpiryStatusColor(colorScheme, daysUntilExpiry)`, `getExpiryStatusIcon`, and `getExpiryStatusLabel`. They already match the mockup.
2. **Use `Theme.of(context)` everywhere** — never hardcode colors. The mockup colors are only for reference.
3. **The medical disclaimer** in Settings → Medical disclaimer must remain — copy from README.md.
4. **Accessibility**: every icon-only button needs a `Semantics` label or `tooltip:`. Match `headlineMedium` for titles so dynamic type scales correctly. Test with TalkBack.
5. **Privacy promise** ("Stays on this phone") is a load-bearing piece of brand copy — keep it on Onboarding and in Settings footer verbatim.
