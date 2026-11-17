# Nizam — Daily Life Planner

One daily planner for classes, training, study, food, work and prayer.
Built with Flutter from a Figma design, with a token-based theme, a fully responsive layout and a feature-first architecture.

![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart)
![State](https://img.shields.io/badge/state-Riverpod%203-1D3B33)
![Tests](https://img.shields.io/badge/tests-34%20passing-B08D3E)

## Features

| Area | What it does |
| --- | --- |
| **Prayer times** | Calculated **offline** for 25 Tunisian cities (Tunisian method, Fajr / Isha 18°), checked against Aladhan within 1 minute; Jumu'a on Fridays |
| **Today** | Next prayer countdown, live weather for tomorrow (Open-Meteo) with advice, tasks due today, the day's plan with NOW marker and ticks, offline notice |
| **Plan** | Week navigation, every day built from real sources: classes, exams, gym days, work shifts, coach when sleeping far, your own events. Tap any block to open it |
| **Add / edit event** | Category, course link, date/time/length pickers, weekly repeat, day-at-a-glance lanes, **prayer-conflict detection** with "move after prayer" |
| **Tasks** | Deadlines with course, filters, overdue / this week / later groups, weekly progress |
| **Timetable** | Faculty timetable from JSON, week navigation, semester week number, session details, weekly work shifts |
| **Training** | Your programme (split per day, workouts, exercises, gym time), workout log with rest timer, history, "vs last time", week streak |
| **Study** | Exams (form, countdown, reminders), grades per subject with coefficient and weights, weighted average, grade calculator, revision goals filled by ticked study sessions, course progress |
| **Food** | Diary saved per day, 34 common Tunisian foods + your own, barcode scanner (Open Food Facts), goals, water, **Ramadan mode** with suhoor / iftar countdown from the real prayer times |
| **Notifications** | Prayer reminders, coach departure, exam the evening before and one hour before (Android / iOS) |
| **Settings** | Name, city, language (English, Français, العربية, Tounsi) with RTL, theme, commute places and coach times, notification toggles |

## Architecture

Feature-first, three layers per feature. Screens only compose widgets; logic lives in controllers and pure domain classes.

```
lib/
├── app/                 App widget (theme, locale, RTL) and router
├── core/
│   ├── theme/           Colours, text styles, dimensions, icons — design tokens
│   ├── responsive/      Screen-relative sizing helpers
│   ├── widgets/         Shared widget kit (card, button, header, tiles, pills…)
│   ├── widgets/forms/   Form kit: form page, text / number / date / time / picker fields, stepper
│   ├── storage/         Local JSON storage + StoredListController (add / edit / delete / save)
│   ├── providers/       App-wide providers (clock, connectivity)
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

Features: `today` · `plan` · `timetable` · `training` · `study` · `food` · `prayers` · `notifications` · `settings` · `onboarding` · `shell`

**Conventions**

- No file is longer than ~135 lines; a screen lists its blocks and nothing else.
- Everything the user enters is saved on the phone. Every editable list extends `StoredListController`, so a new one is a few lines.
- Plan items are not stored twice: classes, exams, gym days, shifts and commutes are generated from their source for each day.
- Works offline. Only the weather and the barcode lookup use the network, and both degrade gracefully.
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

## Data and privacy

Everything is stored locally (`shared_preferences`, JSON documents). Network calls:

- **Open-Meteo** (weather): the chosen city's public coordinates only.
- **Open Food Facts** (barcode lookup): the barcode only.

Fonts are bundled (`assets/fonts`, SIL Open Font License), so the design looks right offline.

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
- **shared_preferences** — local storage
- **http** — weather and product lookup
- **mobile_scanner** — barcode scanning
- **flutter_local_notifications**, **timezone**, **flutter_timezone** — reminders
- **connectivity_plus** — offline notice
- **intl**, **flutter_localizations** — dates, numbers, RTL

## Status

Real data everywhere: timetable from the faculty export, calculated prayer times, live weather, and everything the user enters (exams, grades, goals, workouts, events, tasks, shifts, meals). The training programme starts from an editable push / pull / legs template.

Not done yet:
- **Translations**: the interface text is English. Choosing Arabic switches the layout to RTL, but texts are not translated yet.
- **Home-screen widgets** (Figma 22): need native Android / iOS widget code.
- **Backup / sync**: data lives on one phone; there is no account or cloud copy.
