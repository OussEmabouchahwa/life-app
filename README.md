# Nizam — Daily Life Planner

One daily planner for classes, training, study, food, work and prayer.
Built with Flutter from a Figma design, with a token-based theme, a fully responsive layout and a feature-first architecture.

![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart)
![State](https://img.shields.io/badge/state-Riverpod%203-1D3B33)
![Tests](https://img.shields.io/badge/tests-21%20passing-B08D3E)

## Features

| Area | What it does |
| --- | --- |
| **Today** | Greeting, next prayer with countdown, weather hint, today's plan with a live NOW marker and tick-off |
| **Plan** | Week strip, "tonight I sleep at" + coach times, day blocks, week overview with the heaviest-day warning |
| **Timetable** | Real faculty timetable loaded from JSON, week-by-week navigation, semester week number, session details |
| **Add event** | Category, date, start and length pickers, day-at-a-glance lanes, **prayer-conflict detection** with "move after prayer" |
| **Training** | Weekly split, exercises with progress vs last week, workout log with steppers and a running rest timer |
| **Study** | Exams with countdowns, revision goals, course progress from the timetable, grades table, weighted average |
| **Grade calculator** | "What do I need in the exam?" for a target average |
| **Food** | Calorie ring, macros, meals of the day, add meal with search and per-gram nutrition |
| **Settings** | Language (English, Français, العربية, Tounsi) with automatic RTL, light / dark / system theme, notifications |

## Architecture

Feature-first, three layers per feature. Screens only compose widgets; logic lives in controllers and pure domain classes.

```
lib/
├── app/                 App widget (theme, locale, RTL) and router
├── core/
│   ├── theme/           Colours, text styles, dimensions, icons — design tokens
│   ├── responsive/      Screen-relative sizing helpers
│   ├── widgets/         Shared widget kit (card, button, header, tiles, pills…)
│   ├── providers/       App-wide providers (clock)
│   ├── utils/           Formatting helpers
│   └── ui.dart          Single import for UI code
├── shared/models/       Models used by several features
└── features/
    └── <feature>/
        ├── domain/        Immutable models and pure logic
        ├── data/          Repositories (interfaces + current implementation)
        ├── application/   Riverpod controllers and derived providers
        └── presentation/  Screens and their widgets, one widget per file
```

Features: `today` · `plan` · `timetable` · `training` · `study` · `food` · `prayers` · `settings` · `onboarding` · `shell`

**Conventions**

- No file is longer than ~135 lines; a screen lists its blocks and nothing else.
- Data sources sit behind repository interfaces, so demo data can be replaced by a database or an API without touching the UI.
- Navigation uses `go_router` with one stack per tab and route names in `core/router/routes.dart`.

## Design system

All styling comes from one place — no colours or font sizes are hard-coded in screens.

```dart
context.colors.brand     // colour tokens (light and dark), from the Figma variables
context.text.title       // typography: Fraunces for titles and numbers, Manrope for UI
AppSpacing.gutter        // spacing, radius and size tokens
```

Palette follows a 60 / 30 / 10 rule: parchment backgrounds, bottle green brand, brass accent reserved for the main action, the NOW marker and the active tab.

## Responsive layout

Nothing is sized with a raw constant. Two kinds of helpers (`core/responsive/responsive.dart`):

```dart
context.wp(0.2)   // 20 % of the screen width
context.hp(0.2)   // 20 % of the screen height
context.dp(22)    // a Figma measurement (390-wide frame) scaled to this screen
```

Typography is scaled once in `MaterialApp.builder`, not in every widget. A test pumps every screen at 320, 390 and 430 px wide and fails on any overflow.

## Timetable data

Classes are read from `assets/data/timetable.json` (the faculty export). To update the timetable, replace that file:

```json
{
  "jour": "Lundi",
  "date": "14/09/2026",
  "creneau": "S1 : 8:30 à 11:45",
  "ecue": "GINF.31-1 Introduction à la programmation avancée",
  "professeur": "…",
  "salle": "-"
}
```

Short display names per course code are defined in `lib/features/timetable/data/course_labels.dart`.

## Getting started

Requires Flutter 3.47 or newer.

```bash
flutter pub get
flutter run
```

Run the checks:

```bash
flutter analyze
flutter test
```

## Tech stack

- **Flutter** / **Dart**
- **flutter_riverpod** — state management
- **go_router** — navigation
- **google_fonts** — Fraunces and Manrope
- **shared_preferences** — settings persistence
- **intl** — dates and number formatting

## Status

Working with real data: class timetable.
Still demo data: exams, grades, training programme, work shifts, meals, weather, and prayer times (fixed times for Tunis).

Not built yet from the design: Ramadan food mode, offline state, barcode scanner, tasks & deadlines, home-screen widgets. UI text is English only for now (layout already supports RTL).
