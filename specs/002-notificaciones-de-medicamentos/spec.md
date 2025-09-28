# Feature Specification: Notificaciones de Medicamentos por Caducidad

**Feature Branch**: `002-notificaciones-de-medicamentos`
**Created**: 2025-09-27
**Status**: Implemented
**Input**: User description: "Notificaciones de Medicamentos por Caducidad. Recibir notificaciones automáticas cuando la fecha de caducidad esté próxima (ej. 30, 15, 7, 3 y 1 día antes). Ver en la app qué medicamentos están por caducar o ya caducados.Colorear medicamento en amarillo si faltan ≤ 7 días. Colorear en rojo si está caducado."

---

## User Scenarios & Testing *(mandatory)*

### Primary User Story
As a user, I want to be notified about my medications' expiration dates so that I can manage my inventory and avoid using expired products.

### Secondary User Stories
- As a user, I want to be able to delete a medication that I no longer need to track.
- As a user, I want to be able to assign a medication to a specific family member or for the whole family.
- As a user, I want to be able to add a reason for taking a medication.

### Acceptance Scenarios
1. **Given** a medication has an expiration date 30 days from now, **When** the date is reached, **Then** the system sends a notification.
2. **Given** a medication has an expiration date 7 days from now, **When** I view my medication list, **Then** the medication is highlighted in yellow.
3. **Given** a medication is expired, **When** I view my medication list, **Then** the medication is highlighted in red.
4. **Given** I have medications that are about to expire and some that are already expired, **When** I open the app, **Then** I can easily distinguish between them.
5. **Given** I am editing a medication, **When** I tap the delete button, **Then** a confirmation dialog is displayed.
6. **Given** I have confirmed the deletion of a medication, **When** I return to the medication list, **Then** the medication is no longer visible.
7. **Given** I am adding or editing a medication, **When** I select a user from the dropdown, **Then** the medication is assigned to that user.
8. **Given** I am viewing the medication list, **When** there are medications for different users, **Then** the medications are grouped by user.
9. **Given** I am adding or editing a medication, **When** I enter a reason, **Then** the reason is saved with the medication.
10. **Given** I am viewing the medication list, **When** a medication has a reason, **Then** the reason is displayed under the dosage.

## Clarifications
### Session 2025-09-28
- Q: The specification mentions that the system should handle cases where a medication is entered without an expiration date, and also questions if the expiration date is a mandatory field. How should the system behave in this regard? → A: The expiration date is always mandatory when adding a medication.
- Q: The specification states that notifications should be sent when a medication's expiration date is approaching. How should the system handle these notifications if the app is not running? → A: Notifications are sent via the native OS notification system (e.g., APNS, FCM) and will be displayed even if the app is closed.
- Q: If a user dismisses a notification, should they be reminded again about that same upcoming expiration date? → A: No. Once a notification for a specific date (e.g., the 7-day reminder) is dismissed, it should not appear again.

### Session 2025-09-29
- Q: How should the expiration date be displayed? → A: The expiration date should be displayed in `dd/MM/yyyy` format.
- Q: Should notifications be scheduled for dates in the past? → A: No, notifications should only be scheduled for dates in the future.

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: The system MUST send notifications to the user when a medication's expiration date is approaching (30, 15, 7, 3, and 1 day before).
- **FR-002**: The system MUST provide a view where users can see all medications that are about to expire or are already expired.
- **FR-003**: In the medication list, medications with ≤ 7 days until expiration MUST be visually distinguished with a yellow color.
- **FR-004**: In the medication list, expired medications MUST be visually distinguished with a red color.
- **FR-005**: The system MUST require users to input an expiration date for each medication.
- **FR-006**: Notifications MUST be delivered to the user's device even if the application is not actively running.
- **FR-007**: Once a notification for a specific expiration date has been dismissed by the user, it MUST NOT be sent again.
- **FR-008**: The system MUST allow users to delete a medication.
- **FR-009**: When deleting a medication, the system MUST ask for confirmation.
- **FR-010**: The expiration date MUST be displayed in `dd/MM/yyyy` format.
- **FR-011**: The system MUST NOT schedule notifications for dates in the past.
- **FR-012**: The system MUST allow users to assign a medication to a user or for the whole family.
- **FR-013**: The medication list MUST be grouped by user.
- **FR-014**: The system MUST allow users to add a reason for taking a medication.
- **FR-015**: The reason for taking a medication MUST be displayed in the medication list.

### Key Entities *(include if feature involves data)*
- **Medication**: Represents a medication with attributes such as id, name, dosage, expiration date, user, and reason.
- **User**: Represents a user with attributes such as id and name.
- **Notification**: Represents a reminder sent to the user about a medication's expiration.

---

## Review & Acceptance Checklist
*GATE: Automated checks run during main() execution*

### Content Quality
- [x] No implementation details (languages, frameworks, APIs)
- [x] Focused on user value and business needs
- [x] Written for non-technical stakeholders
- [x] All mandatory sections completed

### Requirement Completeness
- [x] No [NEEDS CLARIFICATION] markers remain
- [x] Requirements are testable and unambiguous
- [x] Success criteria are measurable
- [x] Scope is clearly bounded
- [x] Dependencies and assumptions identified
