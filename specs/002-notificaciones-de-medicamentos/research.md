# Research: Notificaciones de Medicamentos

## Storage Solution for Medications

- **Decision**: Use `hive` for local storage.
- **Rationale**: The project already uses `hive` as its local storage solution. To maintain consistency and avoid introducing a new database dependency, `hive` will be used for storing medication data. Hive is a lightweight and fast key-value database written in pure Dart, which is well-suited for this application.
- **Alternatives considered**: `sqflite`. This was considered but rejected to maintain consistency with the existing project stack.
