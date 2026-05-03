# MedInvent - Home Medicine Inventory Management

A production-ready Flutter Android application for managing home medicine inventory and creating alerts.

## Core Features

### 1. Medicine Inventory Management
- Add, view, edit, and delete medicines with complete details
- Track name, brand, form, strength, quantity, unit, expiry date, location
- Color-coded status indicators (Active, Expiring Soon, Expired)
- Search and filter functionality
- Offline-first storage using Drift (SQLite)

### 2. Alert Creation and Management
- Expiry alerts with configurable lead times (30 days, 7 days, 1 day, on expiry)
- Low stock notifications when quantity reaches threshold
- Optional dose reminders (recurring or one-time)
- Actionable notifications with deep links

## Architecture

This app follows Clean Architecture principles:

```
lib/
├── core/                    # Core utilities, constants, theme
│   ├── constants/
│   ├── error/
│   ├── theme/
│   └── utils/
├── data/                    # Data layer
│   ├── database/           # Drift database setup
│   ├── models/             # Data models and enums
│   ├── repositories/       # Repository implementations
│   └── sources/            # Data sources
├── domain/                  # Business logic layer
│   ├── entities/           # Domain entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Use cases
└── presentation/           # UI layer
    ├── providers/          # Riverpod state management
    ├── screens/            # Screen widgets
    └── widgets/            # Reusable widgets
```

## Tech Stack

- **Framework**: Flutter 3.x (Dart 3, null-safe)
- **State Management**: Riverpod
- **Local Database**: Drift (SQLite)
- **Notifications**: flutter_local_notifications + workmanager
- **UI**: Material 3
- **Security**: flutter_secure_storage

## Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code
- Android SDK (API 29+)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd medinvent
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Drift database code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Build Commands

### Generate Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run Tests
```bash
flutter test
```

### Build APK
```bash
flutter build apk --release
```

### Build App Bundle
```bash
flutter build appbundle --release
```

## Material 3 Implementation

The app strictly follows Material 3 design guidelines from m3.material.io:

- **Color System**: Dynamic color scheme using `ColorScheme.fromSeed()`
- **Components**: FilledButton, OutlinedButton, Cards, Chips, Sheets
- **Typography**: Material 3 type scale (headlineLarge, titleMedium, bodyMedium)
- **Spacing**: 4dp base unit with consistent increments
- **Motion**: Standard easing curves and duration tokens
- **Accessibility**: 48x48 dp minimum touch targets, WCAG AA contrast

## Notification Channels

The app creates three notification channels:

1. **expiry_alerts** (High importance): For medicine expiry notifications
2. **stock_alerts** (Default importance): For low stock warnings
3. **dose_reminders** (Default importance): For dose administration reminders

## Android Permissions

Required permissions in AndroidManifest.xml:

- `RECEIVE_BOOT_COMPLETED`: For scheduled notifications after device restart
- `VIBRATE`: For notification vibration
- `SCHEDULE_EXACT_ALARM`: For precise alarm scheduling (Android 12+)
- `USE_EXACT_ALARM`: Alternative for exact alarms
- `POST_NOTIFICATIONS`: For displaying notifications (Android 13+)

## Testing

### Unit Tests
```bash
flutter test test/unit/
```

### Widget Tests
```bash
flutter test test/widget/
```

### Integration Tests
```bash
flutter test integration_test/
```

## Accessibility

The app supports:
- TalkBack screen reader navigation
- Dynamic text scaling up to 200%
- Minimum 48x48 dp touch targets
- WCAG AA color contrast compliance
- Semantic roles for interactive components

## Security

- Local data encrypted at rest
- No third-party analytics or ads
- Camera images processed entirely in memory (OCR feature)
- No upload of sensitive health data

## Medical Disclaimer

This app is not a substitute for professional medical advice. Always consult with a qualified healthcare provider regarding any medical condition or treatment.

## License

[Your License Here]

## Contributing

[Contribution Guidelines Here]
