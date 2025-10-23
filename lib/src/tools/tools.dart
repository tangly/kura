
class Tools {
// Helper opcional para recuperar datos
  static int extractBaseFromNotificationId(int notificationId) => notificationId ~/ 100;
  static int extractBaseFromMedicationId(String medicationId) {

    // Hash positivo
    final rawHash = medicationId.hashCode & 0x7FFFFFFF;

    // Para asegurar compatibilidad con int32 en notificaciones Android:
    // maxId = 2_147_483_647
    // Queremos: base * 100 + 99 <= maxId
    // base <= (maxId - 99) / 100 = 21_474_835.48...
    const maxBase = 21474835; // seguro
    final base = rawHash % (maxBase + 1);

    return base;
  }

  static int extractDaysFromNotificationId(int id) {
    return id % 100;
  }
}