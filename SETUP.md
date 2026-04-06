# Serene iOS — Setup Guide

## Prerequisites

- macOS 14+ with Xcode 16+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

## Quick Start

### 1. Generate Xcode Project

```bash
cd serene-ios
xcodegen generate
```

This reads `project.yml` and generates `Serene.xcodeproj`.

### 2. Add Fonts

Download and place these fonts in `Serene/Resources/Fonts/`:

- **DM Serif Display**: [Google Fonts](https://fonts.google.com/specimen/DM+Serif+Display)
  - `DMSerifDisplay-Regular.ttf`

- **Plus Jakarta Sans**: [Google Fonts](https://fonts.google.com/specimen/Plus+Jakarta+Sans)
  - `PlusJakartaSans-Regular.ttf`
  - `PlusJakartaSans-Medium.ttf`
  - `PlusJakartaSans-SemiBold.ttf`
  - `PlusJakartaSans-Bold.ttf`

### 3. Set Development Team

Open the generated `.xcodeproj`, go to **Signing & Capabilities**, and set your Development Team.

### 4. Run

Select an iOS 17+ simulator and hit Run.

## Project Structure

```
Serene/
├── App/              # App entry point, AppState
├── Models/           # SwiftData models (Gratitude, Streak, etc.)
├── Views/
│   ├── Components/   # Reusable UI (CoachReplyBubble, TypingIndicator, etc.)
│   ├── Today/        # Main tab: gratitude slots, write sheet, celebration
│   ├── Onboarding/   # 6-step onboarding flow
│   ├── History/      # Past entries with search
│   ├── Insights/     # Weekly summary, patterns (Pro)
│   └── Profile/      # Stats, settings, subscription
├── ViewModels/       # TodayViewModel, OnboardingViewModel
├── Services/         # API, AI Coach, Streak, Notifications
├── Design/           # Colors, Typography, Spacing tokens
└── Resources/
    ├── Assets.xcassets/  # App icon + 14 color sets (light/dark)
    ├── Fonts/            # Custom font files
    └── Info.plist
```
