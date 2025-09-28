# Tasks: Notificaciones de Medicamentos por Caducidad

**Input**: Design documents from `/specs/002-notificaciones-de-medicamentos/`
**Prerequisites**: plan.md (required), research.md, data-model.md, quickstart.md

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Mobile app**: `lib/`, `test/`, `ios/`, `android/` at repository root
- Paths shown below assume mobile app structure

## Phase 3.1: Setup
- [x] T001 Add `flutter_local_notifications` dependency to `pubspec.yaml`.
- [x] T002 Configure `flutter_local_notifications` for iOS and Android following the package instructions.

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [x] T003 [P] Write a unit test for the `Medication` model in `test/unit/medication_test.dart`.
- [x] T004 [P] Write a unit test for the `MedicationService` in `test/services/medication_service_test.dart`. This test should cover adding, retrieving, updating, and deleting medications.
- [x] T005 [P] Write a widget test for the medication list screen in `test/widget/medication_list_screen_test.dart`. This test should verify that medications are displayed correctly, with the correct highlighting for expiring and expired medications.
- [x] T006 [P] Write a unit test for the notification service in `test/services/notification_service_test.dart`.

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [x] T007 [P] Create the `Medication` model in `lib/src/models/medication.dart` with `HiveType` annotations.
- [x] T008 Generate the `Medication` adapter using `build_runner` by running `flutter packages pub run build_runner build`.
- [x] T009 Create the `MedicationService` in `lib/src/services/medication_service.dart`. This service will handle all CRUD operations for medications using Hive.
- [x] T010 Create the `NotificationService` in `lib/src/services/notification_service.dart`. This service will handle scheduling and displaying notifications.
- [x] T011 Create the medication list screen UI in `lib/src/views/medication_list_screen.dart`. This screen will display the list of medications.
- [x] T012 Create the add/edit medication screen UI in `lib/src/views/add_edit_medication_screen.dart`.

## Phase 3.4: Integration
- [x] T013 Integrate the `MedicationService` with the medication list screen and the add/edit medication screen using Riverpod.
- [x] T014 Integrate the `NotificationService` to schedule notifications when a new medication is added or updated.

## Phase 3.5: Polish
- [x] T015 [P] Add accessibility features (e.g., Semantics) to the medication list and add/edit screens.
- [x] T016 [P] Update the `README.md` with instructions on how to use the new feature.
- [x] T017 Code cleanup and refactoring.
- [x] T018 Run integration tests on a real device.

## Dependencies
- T001, T002 must be done before all other tasks.
- Tests (T003-T006) before implementation (T007-T012).
- T007 blocks T008.
- T009 and T010 block T013 and T014.
- Implementation before polish (T015-T018).

## Parallel Example
```
# Launch T003-T006 together:
Task: "Write a unit test for the Medication model in test/unit/medication_test.dart"
Task: "Write a unit test for the MedicationService in test/services/medication_service_test.dart"
Task: "Write a widget test for the medication list screen in test/widget/medication_list_screen_test.dart"
Task: "Write a unit test for the notification service in test/services/notification_service_test.dart"
```
