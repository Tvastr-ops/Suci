# Suci

A minimalist, local-first literature and web serial tracker for Android.

Built to track fiction that does not fit into standard book or manga databases: web novels, fanfiction, Original English Light Novels (OELs), and serialized fiction.

Completely offline and local-first. No accounts, no cloud servers, and no web scrapers.

## Features

- **Progress tracking**: Track by chapters, volumes and chapters, word count, or percentage.
- **Fast updates**: One-tap chapter increment directly from the library list.
- **Shelves**: Reading, Plan to Read, On Hold, Completed, and Dropped with status counts.
- **Metadata**: Formats, tags, serialization status (ongoing, completed, hiatus, cancelled), ratings, personal notes, and blurb.
- **Source links**: Store source URLs with direct browser opening and domain detection for platforms like Royal Road, AO3, Scribble Hub, FFN, and Spacebattles.
- **Design**: Material Design 3 with dynamic color support on Android 12+ and typographic cover fallbacks.
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
