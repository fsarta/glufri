class SyncService {
  Future<void> backupToCloud() async {
    // 1. Prendi tutti i dati da Hive
    // 2. Serializzali in una mappa (JSON)
    // 3. Caricali su Cloud Firestore in una collection dell'utente
    print("Starting backup...");
  }

  Future<void> restoreFromCloud() async {
    // 1. Scarica i dati da Firestore
    // 2. Deserializzali nei modelli Hive
    // 3. Popola Hive (con logica di merge per evitare duplicati)
    print("Starting restore...");
  }
}
