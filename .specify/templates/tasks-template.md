
# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. Generate tasks by category:
   → Setup: project init, dependencies, linting
   → Tests: contract tests, integration tests
   → Core: models, services, CLI commands
   → Integration: DB, middleware, logging
   → Polish: unit tests, performance, docs
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All contracts have tests?
   → All entities have models?
   → All endpoints implemented?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Mobile app**: `lib/`, `test/`, `ios/`, `android/` at repository root
- Paths shown below assume mobile app structure

## Phase 3.1: Setup
- [ ] T001 Create Flutter project structure per implementation plan
- [ ] T002 Add Flutter dependencies (e.g., provider, http) to pubspec.yaml
- [ ] T003 [P] Configure linting and formatting tools (e.g., analysis_options.yaml)

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [ ] T004 [P] Widget test for Login Screen in `test/widget/login_screen_test.dart`
- [ ] T005 [P] Widget test for Home Screen in `test/widget/home_screen_test.dart`
- [ ] T006 [P] Unit test for AuthService in `test/services/auth_service_test.dart`
- [ ] T007 [P] Unit test for ApiService in `test/services/api_service_test.dart`

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [ ] T008 [P] User model in `lib/src/models/user.dart`
- [ ] T009 [P] AuthService implementation in `lib/src/services/auth_service.dart`
- [ ] T010 [P] ApiService implementation in `lib/src/services/api_service.dart`
- [ ] T011 Login Screen UI in `lib/src/views/login_screen.dart`
- [ ] T012 Home Screen UI in `lib/src/views/home_screen.dart`
- [ ] T013 Input validation for login form
- [ ] T014 Error handling and user feedback

## Phase 3.4: Integration
- [ ] T015 Integrate AuthService with Login Screen
- [ ] T016 Integrate ApiService with Home Screen
- [ ] T017 Add state management (e.g., Provider, BLoC)
- [ ] T018 Implement navigation between screens

## Phase 3.5: Polish
- [ ] T019 [P] Add accessibility features (e.g., Semantics)
- [ ] T020 Performance tests (e.g., startup time, frame rate)
- [ ] T021 [P] Update README.md with setup and run instructions
- [ ] T022 Code cleanup and refactoring
- [ ] T023 Run integration tests on a real device

## Dependencies
- Tests (T004-T007) before implementation (T008-T014)
- T008 blocks T009, T015
- T017 blocks T018
- Implementation before polish (T019-T023)

## Parallel Example
```
# Launch T004-T007 together:
Task: "Widget test for Login Screen in test/widget/login_screen_test.dart"
Task: "Widget test for Home Screen in test/widget/home_screen_test.dart"
Task: "Unit test for AuthService in test/services/auth_service_test.dart"
Task: "Unit test for ApiService in test/services/api_service_test.dart"
```

## Notes
- [P] tasks = different files, no dependencies
- Verify tests fail before implementing
- Commit after each task
- Avoid: vague tasks, same file conflicts

## Task Generation Rules
*Applied during main() execution*

1. **From Contracts**:
   - Each contract file → contract test task [P]
   - Each endpoint → implementation task
   
2. **From Data Model**:
   - Each entity → model creation task [P]
   - Relationships → service layer tasks
   
3. **From User Stories**:
   - Each story → integration test [P]
   - Quickstart scenarios → validation tasks

4. **Ordering**:
   - Setup → Tests → Models → Services → Endpoints → Polish
   - Dependencies block parallel execution

## Validation Checklist
*GATE: Checked by main() before returning*

- [ ] All contracts have corresponding tests
- [ ] All entities have model tasks
- [ ] All tests come before implementation
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same file as another [P] task