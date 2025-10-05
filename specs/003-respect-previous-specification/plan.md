# Implementation Plan: Modern and Enjoyable Theme

**Input**: `/Users/stephane/dev/kura/specs/003-respect-previous-specification/spec.md`

## Technical Context
This feature requires updating the Flutter application's UI to implement a new, modern theme based on Material 3. The core of the work involves defining a global `ThemeData` using a seed color ("pharmacy green") and ensuring all existing widgets and screens adopt this theme correctly. The app must also support system-level light and dark modes.

---

## Execution Flow

### Phase 0: Research
- **Status**: [x] Complete
- **Summary**: Research confirmed that Material 3 theming in Flutter, using `ColorScheme.fromSeed`, is the correct approach. It fully supports generating both light and dark color schemes from a single seed color and can be configured to follow system theme settings.
- **Artifacts**: `research.md`

### Phase 1: Data Model & Contracts
- **Status**: [x] Complete
- **Summary**: This feature is purely presentational. No changes to the data model or API contracts are necessary.
- **Artifacts**: `data-model.md`, `quickstart.md`

### Phase 2: Task Breakdown
- **Status**: [x] Complete
- **Summary**: The implementation has been broken down into specific tasks, including updating `main.dart` with the new theme definitions and refactoring existing UI files to remove hardcoded styles.
- **Artifacts**: `tasks.md`

---

## Progress Tracking
- [x] Phase 0: Research
- [x] Phase 1: Data Model & Contracts
- [x] Phase 2: Task Breakdown