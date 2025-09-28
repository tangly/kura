# Quickstart: Medication Expiration Notifications

This document outlines the steps to test the medication expiration notification feature.

## Prerequisites

- The application is installed on an iOS or Android device.
- The user has granted permission for the app to send notifications.

## Test Scenarios

### Scenario 1: Receive a notification for an upcoming expiration

1.  Add a new medication with an expiration date 30 days from today.
2.  Wait for the notification to be triggered on the 30th day before expiration.
3.  **Expected Result**: A notification is received on the device.

### Scenario 2: View a medication that is about to expire

1.  Add a new medication with an expiration date 7 days from today.
2.  Navigate to the medication list screen.
3.  **Expected Result**: The medication is highlighted in yellow.

### Scenario 3: View an expired medication

1.  Add a new medication with an expiration date that has already passed.
2.  Navigate to the medication list screen.
3.  **Expected Result**: The medication is highlighted in red.

### Scenario 4: Distinguish between expiring and expired medications

1.  Add a medication with an expiration date 5 days from today.
2.  Add another medication with an expiration date that has already passed.
3.  Navigate to the medication list screen.
4.  **Expected Result**: The first medication is highlighted in yellow, and the second medication is highlighted in red.
