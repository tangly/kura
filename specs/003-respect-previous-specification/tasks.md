# Task Breakdown: Modern Theme Implementation

- [x] **Task 1: Define New Theme in `main.dart`**
  - In `main.dart`, modify the `MaterialApp` widget.
  - Create a light `ThemeData` using `ColorScheme.fromSeed` with the "pharmacy green" color and `useMaterial3: true`.
  - Create a dark `ThemeData` using `ColorScheme.fromSeed` with the same seed color, `brightness: Brightness.dark`, and `useMaterial3: true`.
  - Set the `theme` and `darkTheme` properties of `MaterialApp`.
  - Set `themeMode: ThemeMode.system` to enable automatic theme switching.

- [x] **Task 2: Refactor `medication_list_item.dart`**
  - Remove hardcoded `Colors.red` and `Colors.yellow`.
  - Replace them with theme-based colors, such as `Theme.of(context).colorScheme.errorContainer` for expired items and `Theme.of(context).colorScheme.tertiaryContainer` for items expiring soon.
  - Ensure all text styles inherit from the main theme.

- [x] **Task 3: Refactor `add_edit_medication_screen.dart`**
  - Review all UI components (TextFormFields, Buttons, Icons).
  - Remove any hardcoded colors or styles.
  - Ensure all components correctly use the new `ThemeData`.

- [x] **Task 4: Refactor `medication_list_screen.dart`**
  - Verify that the `ExpansionTile`, `ListView`, and `FloatingActionButton` correctly adopt the new theme styles.

- [x] **Task 5: Final Review and Verification**
  - Launch the application on a device or emulator.
  - Verify that the "pharmacy green" based theme is applied correctly.
  - Switch the device between light and dark mode to confirm the theme adapts as expected.
  - Navigate through all screens to check for any remaining hardcoded styles or visual inconsistencies.
