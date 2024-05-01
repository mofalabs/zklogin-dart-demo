import 'package:flutter/material.dart';
import 'package:sui_dart_zklogin_demo/data/storage_manager.dart';
import 'package:sui_dart_zklogin_demo/page/zklogin_page.dart'
    if (dart.library.html) 'package:sui_dart_zklogin_demo/page/zklogin_web_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ZkLoginStorageManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ZkLoginPage(),
    );
  }
}
