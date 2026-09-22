# THE RANGE Smart Home

> **One ecosystem for the whole home** — Flutter app for the THE RANGE smart home product range.

---

## Features

| Screen | Description |
|---|---|
| **Onboarding** | 5-page animated splash with feature highlights |
| **Home** | Device grid with room tabs, live toggle, pull-to-refresh |
| **Scenes** | Tap-to-run grid + Automation list with enable/disable toggles |
| **Protect** | Live camera viewer, door lock, face/fingerprint, event log |
| **Energy** | Bar chart (fl_chart), device breakdown, AI saving banner |
| **AI** | Chat assistant, AI Services list, Health vitals + AI Notes |
| **Products** | Full product catalogue — all 7 categories, expandable cards |
| **Device Detail** | Per-device controls (light brightness, thermostat, curtain %) |

## Ecosystem

- Tuya / Smart Life · Zigbee 3.0 · Wi-Fi · MQTT  
- Amazon Alexa · Google Assistant · Yandex Alice

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0 — [install](https://docs.flutter.dev/get-started/install)
- Dart SDK ≥ 3.0.0 (bundled with Flutter)
- Android Studio or VS Code with Flutter extension

### Install & Run

```bash
cd "the_range_smart_home"
flutter pub get
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

### Build iOS

```bash
flutter build ios --release
```

---

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── theme/
│   ├── app_colors.dart          # All colours, gradients, shadows
│   └── app_theme.dart           # Light & dark ThemeData
├── models/
│   ├── app_state.dart           # ChangeNotifier state (Provider)
│   ├── device.dart              # Device model + enums
│   ├── scene.dart               # Scene model
│   └── room.dart                # Room model
├── data/
│   └── mock_data.dart           # All mock devices, scenes, energy data
├── screens/
│   ├── onboarding_screen.dart   # 5-page onboarding
│   ├── main_shell.dart          # Bottom nav shell
│   ├── home_screen.dart         # Device management
│   ├── scenes_screen.dart       # Scenes & automations
│   ├── security_screen.dart     # Protect / cameras / locks
│   ├── energy_screen.dart       # AI energy saving + charts
│   ├── ai_screen.dart           # AI chat + services + health
│   ├── products_screen.dart     # Product catalogue
│   └── device_detail_screen.dart # Per-device controls
└── widgets/
    ├── device_card.dart          # Reusable device card with toggle
    ├── scene_card.dart           # Scene card + automation row
    ├── section_header.dart       # Section title + action link
    └── stat_chip.dart            # Stat display chip
```

---

## Dependencies

| Package | Use |
|---|---|
| `provider` | State management |
| `google_fonts` | Inter typeface |
| `fl_chart` | Bar/line charts on Energy screen |
| `percent_indicator` | Progress rings |
| `flutter_svg` | SVG icon support |
| `intl` | Date/number formatting |

---

## Connecting Real Devices

The app is designed for Tuya-based devices. To wire up real device control:

1. Sign up at [iot.tuya.com](https://iot.tuya.com) and get API credentials.
2. Add `tuya_smart_device` or use the Tuya Cloud API via `http`/`dio`.
3. Replace `MockData` calls in `AppState` with live API responses.
4. For Zigbee, deploy a Zigbee2MQTT broker and connect via the `mqtt_client` package.

---

## Licence

© THE RANGE. All rights reserved.
