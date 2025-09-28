# Data Model: Medication

## Medication Entity

| Field | Type | Description | Constraints |
|---|---|---|---|
| id | INTEGER | Unique identifier | PRIMARY KEY, AUTOINCREMENT |
| name | TEXT | Name of the medication | NOT NULL |
| dosage | TEXT | Dosage of the medication | NULLABLE |
| expirationDate | TEXT | Expiration date of the medication in ISO 8601 format (YYYY-MM-DD) | NOT NULL |
