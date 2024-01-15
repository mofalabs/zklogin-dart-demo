import 'package:flutter/material.dart';
import 'package:sui/cryptography/ed25519_keypair.dart';
import 'package:sui/sui_account.dart';

import 'page/step_one.dart';

void main() {
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SuiAccount? account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(15),
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            children: [
              StepOnePage(
                account: account,
                clearClick: () {
                  account = null;
                  setState(() {});
                },
                createClick: () {
                  account = SuiAccount(Ed25519Keypair());
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
