// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/cep_lookup_page.dart'; // Importa nossa tela principal

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const CepLookupPage(), // Define a tela inicial
    );
  }
}
