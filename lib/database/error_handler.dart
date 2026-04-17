import 'package:drift/native.dart';

class DatabaseErrorExtractor {
  /// Checks if an exception is a storage-full error (SQLITE_FULL - code 13).
  static bool isStorageFull(Object error) {
    if (error is SqliteException) {
      // Extended error code 13 is SQLITE_FULL
      // We also check error.resultCode if needed, but extendedErrorCode is more precise
      return error.extendedResultCode == 13 || error.resultCode == 13;
    }
    return false;
  }

  /// Helper to ensure we don't have orphaned transactions if possible.
  /// Note: Drift handles transaction rollback automatically if a Future fails,
  /// but this utility provides a hook for explicit logging or recovery.
  static bool wasTransactionFailure(Object error) {
    // SqliteException 13 mid-transaction will cause a rollback in Drift.
    return isStorageFull(error);
  }
}
