import 'package:flutter/material.dart';
import 'package:manejementugas/ui/tugas_form.dart';
import 'package:manejementugas/ui/tugas_page.dart';
import 'package:manejementugas/ui/tugas_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Manajemen Tugas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TugasPage(), // Menghubungkan ke halaman TugasForm
    );
  }
}