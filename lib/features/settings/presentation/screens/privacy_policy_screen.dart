import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informativa Privacy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text("""
          La tua privacy è importante... 
          [INSERIRE QUI IL TESTO COMPLETO DELLA PRIVACY POLICY]
          
          Dati Raccolti: L'app salva i dati degli acquisti esclusivamente sul tuo dispositivo. Se scegli di utilizzare la funzione di backup cloud (funzionalità Pro), i tuoi dati verranno criptati e salvati sui server sicuri di Google Firebase.
          
          Condivisione Dati: Nessun dato personale o di acquisto viene condiviso con terze parti.
          ...
          """),
      ),
    );
  }
}
