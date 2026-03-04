# tracket

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

 - [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
 - [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## FVM (Flutter Version Management)

This repository is configured to use FVM. The project contains a `.fvmrc` file
that pins the Flutter SDK channel/version for contributors.

- To install FVM (if not installed):

```bash
# via pub
dart pub global activate fvm
# or via brew on macOS
# brew tap leoafarias/fvm && brew install fvm
```

- Install and use the pinned SDK and run package commands:

```bash
cd "$(dirname "${BASH_SOURCE[0]}")"
fvm install
fvm use
fvm flutter pub get
```

- Running Flutter commands via FVM:

```bash
fvm flutter run
fvm flutter build apk
```

If you prefer using the normal `flutter` command, you can alias it in your shell:

```bash
alias flutter="fvm flutter"
```

Note: The workspace VS Code setting is configured to point the Dart/Flutter
extension at `.fvm/flutter_sdk` so the editor uses the same SDK as FVM.
