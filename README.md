# Glufri - Gluten-Free Tracker

Questa è un'app Flutter per tracciare gli acquisti di prodotti senza glutine, costruita con un'architettura offline-first.

## Setup del Progetto

1.  **Installa Flutter:** Assicurati di avere l'ultima versione stabile di Flutter.
    ```bash
    flutter --version
    ```
2.  **Clona il repository:**
    ```bash
    git clone [URL_DEL_TUO_REPO]
    cd glufri
    ```
3.  **Installa le dipendenze:**
    ```bash
    flutter pub get
    ```
4.  **Genera il codice di localizzazione:**
    ```bash
    flutter gen-l10n
    ```
5.  **Genera il codice per Hive (Models):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
