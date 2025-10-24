# Requirements Document

## Introduction
This document outlines the requirements for the "Add/Edit Prescription" feature. This feature will allow users to manage their medication prescriptions, including setting up flexible schedules and receiving notifications as reminders.

## Requirements

### Requirement 1: Manage Prescriptions
**User Story:** As a user, I want to add and edit my prescriptions, so that I can accurately track my medication intake.

#### Acceptance Criteria
1.  **WHEN** a user navigates to the "add prescription" screen, **THEN** the system **SHALL** display a form to enter prescription details.
2.  **THE** prescription form **SHALL** include fields for:
    *   Medication Name (text)
    *   Dosage (e.g., "1 pill", "25ml")
    *   Repetition schedule (e.g., "every day", "every 8 hours", "on Mondays and Fridays")
    *   Start date
    *   Duration of the prescription
3.  **WHEN** the user saves a new prescription, **THEN** the system **SHALL** validate the provided information and save the prescription.
4.  **WHEN** a user selects an existing prescription to edit, **THEN** the system **SHALL** populate the form with the saved details of that prescription.
5.  **WHEN** the user confirms their edits, **THEN** the system **SHALL** update the prescription with the new information.

### Requirement 2: Prescription Notifications
**User Story:** As a user, I want to receive timely reminders for my medications, so that I can adhere to my prescription schedule.

#### Acceptance Criteria
1.  **IF** a prescription is active, **THEN** the system **SHALL** schedule notifications based on the specified repetition schedule, start date, and duration.
2.  **WHEN** a scheduled medication time occurs, **THEN** the system **SHALL** trigger a notification on the user's device.
3.  **THE** notification **SHALL** clearly state the medication name and the dosage to be taken.
4.  **IF** the user updates the prescription schedule, **THEN** the system **SHALL** reschedule the notifications accordingly.
