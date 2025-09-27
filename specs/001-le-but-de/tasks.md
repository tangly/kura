# Tasks: Medication Manager

**Input**: Design documents from `/specs/001-le-but-de/`
**Prerequisites**: plan.md (required), research.md, data-model.md

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Mobile app**: `lib/`, `test/`, `ios/`, `android/` at repository root
- Paths shown below assume mobile app structure

## Phase 3.1: Setup
- [X] T001 Create Flutter project named "kura"
- [X] T002 Add dependencies to `pubspec.yaml`: `flutter_riverpod`, `hive`, `hive_flutter`
- [X] T003 [P] Configure linting rules in `analysis_options.yaml`

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [X] T004 [P] Write widget test for Medication List Screen in `test/widget/medication_list_screen_test.dart`
- [X] T005 [P] Write widget test for Add/Edit Medication Screen in `test/widget/add_edit_medication_screen_test.dart`
- [X] T006 [P] Write unit test for MedicationService in `test/services/medication_service_test.dart`

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [X] T007 [P] Create `Medication` model in `lib/src/models/medication.dart`
- [X] T008 [P] Create `User` model in `lib/src/models/user.dart`
- [X] T009 Implement `MedicationService` for CRUD operations in `lib/src/services/medication_service.dart`
- [X] T010 Implement Medication List Screen UI in `lib/src/views/medication_list_screen.dart`
- [X] T011 Implement Add/Edit Medication Screen UI in `lib/src/views/add_edit_medication_screen.dart`
- [X] T012 Implement input validation for the Add/Edit Medication form

## Phase 3.4: Integration
- [X] T013 Initialize Hive database in `main.dart`
- [X] T014 Integrate `MedicationService` with Riverpod providers
- [X] T015 Integrate Medication List Screen with `MedicationService`
- [X] T016 Integrate Add/Edit Medication Screen with `MedicationService`
- [X] T017 Implement navigation between screens

## Phase 3.5: Polish
- [X] T018 [P] Add accessibility features (Semantics)
- [X] T019 [P] Update `README.md` with setup and run instructions
- [X] T020 Code cleanup and refactoring
- [X] T021 Run integration tests on a real device

## Dependencies
- Tests (T004-T006) before implementation (T007-T012)
- T007, T008 block T009
- T009 blocks T014, T015, T016
- T013 blocks T009
- Implementation before polish (T018-T021)
