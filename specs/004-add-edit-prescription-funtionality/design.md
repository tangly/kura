# Design Document: Add/Edit Prescription

## 1. Overview
This document details the design for the "Add/Edit Prescription" feature. The feature will allow users to create, edit, and manage their medication prescriptions. It includes a flexible scheduling mechanism and local notifications to remind users to take their medication.

## 2. Architecture
The feature will be implemented within the existing Flutter application, following the current architecture. We will use a provider-based state management solution (as suggested by `providers.dart` in the project structure). The data will be stored in Firestore. Prescriptions will be stored as a subcollection of the `members` collection.

The main components will be:
- **UI Layer:** A screen for adding/editing prescriptions, and updates to the medication list view.
- **State Management:** A provider to manage the state of the prescriptions.
- **Service Layer:** A service to handle the business logic, including scheduling notifications.
- **Data Layer:** A repository to handle the storage of prescription data.

## 3. Components and Interfaces

### 3.1. UI Components
- **`AddEditPrescriptionScreen`:** A stateful widget containing a form to add or edit a prescription.
    - **Medication Name:** A `TextFormField`.
    - **Dosage:** Two `TextFormField`s, one for the quantity (numeric) and one for the unit (text).
    - **Repetition Schedule:** A set of widgets to configure the repetition rule. This will be a custom component.
        - It will have a simple view with common options like "Every day", "Every X hours".
        - An "Advanced" or "Custom" option will reveal a more complex interface to select days of the week, or other patterns.
    - **Start Date:** A `DatePicker`.
    - **Duration:** A `TextFormField` for the number and a dropdown for the unit (days, weeks, months).
- **`PrescriptionListScreen`:** The existing screen will be updated to show the list of prescriptions.

### 3.2. State Management
- **`PrescriptionProvider`:** A `ChangeNotifier` that will:
    - Hold the list of prescriptions for a specific member.
    - Provide methods to add, edit, and delete prescriptions for a member.
    - Load prescriptions from the data layer for a member.

### 3.3. Services
- **`NotificationService`:** A service responsible for:
    - Scheduling local notifications using the `flutter_local_notifications` package.
    - Cancelling notifications when a prescription is deleted or edited.
    - It will be initialized in `main.dart`.
- **`PrescriptionService`:** A service to:
    - Contain the business logic for managing prescriptions.
    - Calculate the notification schedule based on the repetition rule.

### 3.4. Data Layer
- **`PrescriptionRepository`:** A class responsible for:
    - Storing, retrieving, updating, and deleting prescriptions from Firestore using the `cloud_firestore` package.
    - Prescriptions will be stored under the path `members/{memberId}/prescriptions/{prescriptionId}`.

## 4. Data Models

```mermaid
classDiagram
    class Member {
        +String id
    }

    class Prescription {
        +String id
        +String medicationName
        +Dosage dosage
        +RepetitionRule repetitionRule
        +DateTime startDate
        +Duration duration
    }

    class Dosage {
        +double quantity
        +String unit
    }

    class RepetitionRule {
        +RepetitionType type
        +int? interval
        +List<int>? daysOfWeek
    }

    enum RepetitionType {
        DAILY
        HOURLY
        WEEKLY
        CUSTOM
    }

    Member "1" -- "*" Prescription
    Prescription "1" -- "1" Dosage
    Prescription "1" -- "1" RepetitionRule
```

- **`Member`:** A `Member` model is assumed to exist, with a unique `id`. The `Prescription` will be associated with a member.
- **`Prescription`:** The main data model for a prescription.
- **`Dosage`:** Represents the dosage of the medication.
- **`RepetitionRule`:** Represents the repetition schedule.
    - `type`: An enum to define the type of repetition.
    - `interval`: For hourly or daily repetitions (e.g., every 8 hours, every 2 days).
    - `daysOfWeek`: For weekly repetitions, a list of integers representing the days of the week (e.g., `[1, 3, 5]` for Monday, Wednesday, Friday).

## 5. Error Handling
- **Form Validation:** The `AddEditPrescriptionScreen` will have validation for all fields.
- **Database Errors:** The `PrescriptionRepository` will handle Firestore errors (e.g., permissions) and propagate them to the service layer. The UI will show a user-friendly error message.
- **Notification Errors:** The `NotificationService` will log any errors related to scheduling notifications.

## 6. Testing Strategy
- **Unit Tests:**
    - Test the business logic in the `PrescriptionService`, especially the notification scheduling logic.
    - Test the `PrescriptionRepository` with a mock Firestore instance (`fake_cloud_firestore`).
    - Test the `PrescriptionProvider`.
- **Widget Tests:**
    - Test the `AddEditPrescriptionScreen` form, including validation.
    - Test the `PrescriptionListScreen` to ensure it displays the prescriptions correctly.
- **Integration Tests:**
    - Test the full flow of adding a prescription and verifying that a notification is scheduled.
