# Research: Implementing a Modern Theme in Flutter

**Date**: 2025-09-28

## Objective
Investigate the best practices for implementing a modern, Material 3-based theme in the existing Flutter application, focusing on dynamic color generation, light/dark mode support, and component styling.

## Key Findings

### 1. Material 3 Theming in Flutter
- **Enabling Material 3**: The `ThemeData` constructor has a `useMaterial3` flag that must be set to `true`.
- **Color System**: Material 3 uses a `ColorScheme` object. Instead of defining all colors manually, it's recommended to generate them from a single seed color using `ColorScheme.fromSeed()`.
- **Dynamic Color**: This approach allows for easy generation of a full, harmonious color palette for both light and dark modes from our chosen "pharmacy green" seed color.

### 2. Light and Dark Mode
- **System Theme**: The `MaterialApp` widget has a `themeMode` property. Setting it to `ThemeMode.system` will make the app automatically adapt to the user's OS-level light or dark mode setting.
- **Defining Themes**: We need to provide two `ThemeData` objects to `MaterialApp`: one for `theme` (light) and one for `darkTheme` (dark). Both will be generated from the same green seed color to ensure consistency.

### 3. Component Styling
- **Default Styles**: When `useMaterial3` is true, most Flutter widgets (like `AppBar`, `ElevatedButton`, `Card`) will automatically adopt the new Material 3 styles defined in the `ThemeData`.
- **Customization**: For specific overrides, `ThemeData` has properties like `elevatedButtonTheme`, `cardTheme`, etc., which can be used for fine-tuning.
- **Accessing Theme Colors**: Instead of using hardcoded colors (e.g., `Colors.red`), we must refactor the UI to use colors from the theme, such as `Theme.of(context).colorScheme.primary` or `Theme.of(context).colorScheme.error`.

## Conclusion
The implementation is straightforward. We will define a `ColorScheme` using `ColorScheme.fromSeed` with our "pharmacy green" color, create a `ThemeData` object with `useMaterial3: true` for both light and dark modes, and set the `MaterialApp` to follow the system theme. The main effort will be in refactoring existing widgets to remove hardcoded colors and styles, ensuring they correctly inherit from the new theme.
