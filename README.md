# Suci

A minimalist, local-first literature and web serial tracker for Android.

Built to track fiction that does not fit into standard book or manga databases: web novels, fanfiction, Original English Light Novels (OELs), and serialized fiction.

Local-first and privacy-focused. All reading data, shelves, history, and notes stay strictly on your device in a local SQLite database. No accounts, no telemetry, no tracking, and no external servers. Internet access is used exclusively when loading external cover image URLs that you configure.

## Features

- **Progress tracking**: Track by chapters, volumes and chapters, word count, or percentage.
- **Fast updates**: One-tap chapter increment directly from the library list.
- **Shelves**: Reading, Plan to Read, On Hold, Completed, and Dropped with status counts.
- **Metadata**: Formats (Web Novel, Light Novel, OEL, Fanfiction, Published Fiction, Short Story), tags, serialization status, ratings, personal notes, and blurb.
- **Covers**: Add covers via local gallery images, direct image URLs, or automatic typographic fallbacks.
- **Source links**: Store source URLs with direct browser opening and domain detection for platforms like Royal Road, AO3, Scribble Hub, FFN, and Spacebattles.
- **Design**: Material Design 3 with Dynamic Color (Material You) on Android 12+, 7 curated theme palettes, dark/light modes, and adaptive launcher icon.
- **Privacy & Security**: Optional App Lock with private 4-digit PIN, isolated biometric unlock (fingerprint/face), brute-force lockout protection, and automatic obscuring in Android recent apps.
- **Backup and export**: Versioned JSON backup (merge and overwrite modes), CSV export, full ZIP archive export, and Android share sheet support.

## Tech Stack

- **Framework**: Flutter (Android-only)
- **Database**: SQLite via Drift
- **State Management**: Riverpod
- **Routing**: go_router

## Build Instructions

### Requirements
- Flutter SDK (stable channel)
- Java 17
- Android SDK

### Commands
```bash
# Get packages
flutter pub get

# Run tests
flutter test

# Static analysis
flutter analyze

# Build release APK (Universal)
flutter build apk --release

# Build release APK (arm64-v8a)
flutter build apk --release --target-platform android-arm64
```

## License

MIT
