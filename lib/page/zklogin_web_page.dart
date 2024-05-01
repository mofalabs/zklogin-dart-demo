import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sui/sui.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/data/constants.dart';
import 'package:sui_dart_zklogin_demo/data/storage_manager.dart';
import 'package:sui_dart_zklogin_demo/page/step_five.dart';
import 'package:sui_dart_zklogin_demo/page/step_four.dart';
import 'package:sui_dart_zklogin_demo/page/step_one.dart';
import 'package:sui_dart_zklogin_demo/page/step_seven.dart';
import 'package:sui_dart_zklogin_demo/page/step_six.dart';
import 'package:sui_dart_zklogin_demo/page/step_three.dart';
import 'package:sui_dart_zklogin_demo/page/step_two_web.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';

class ZkLoginPage extends StatefulWidget {
  const ZkLoginPage({super.key});

  @override
  State<ZkLoginPage> createState() => _ZkLoginPageState();
}

class _ZkLoginPageState extends State<ZkLoginPage> {
  final controller = ScrollController();

  final ZkLoginProvider provider = ZkLoginProvider();

  List<String> steps = [
    'Generate Ephemeral Key Pair',
    'Fetch JWT',
    'Decode JWT',
    'Generate Salt',
    'Generate user Sui address',
    'Fetch ZK Proof',
    'Assemble zkLogin signature',
  ];

  @override
  void initState() {
    super.initState();
    _recoverCacheData();
  }

  _recoverCacheData() {
    final url = html.window.location.href;
    if (url.startsWith(Constant.replaceUrl)) {
      var keyPair = ZkLoginStorageManager.getTemporaryCacheKeyPair();
      var maxEpoch = ZkLoginStorageManager.getTemporaryMaxEpoch();
      var nonce = ZkLoginStorageManager.getTemporaryCacheNonce();
      var randomness = ZkLoginStorageManager.getTemporaryRandomness();

      if (keyPair.isNotEmpty &&
          maxEpoch > 0 &&
          nonce.isNotEmpty &&
          randomness.isNotEmpty) {
        String temp = url.replaceAll(Constant.replaceUrl, '');
        provider.jwt = temp.substring(0, temp.indexOf('&'));
        provider.nonce = nonce;
        provider.maxEpoch = maxEpoch;
        provider.randomness = randomness;
        provider.account = SuiAccount.fromPrivateKey(
          keyPair,
          SignatureScheme.Ed25519,
        );
        provider.step = 4;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Consumer<ZkLoginProvider>(
        builder: (_, v, __) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sui zkLogin Dart Demo')),
            body: SingleChildScrollView(
              controller: controller,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: width < 600 ? 20 : 40,
                  horizontal: width < 600 ? 15 : 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _stepWidgets(),
                    const SizedBox(height: 25),
                    _contentWidgets()[provider.step - 1],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _stepWidgets() {
    return Wrap(
      runSpacing: 15,
      children: steps
          .map(
            (e) => Chip(
              avatar: CircleAvatar(
                backgroundColor: steps.indexOf(e) < provider.step
                    ? AppTheme.textColor1
                    : AppTheme.unClickColor,
                child: Text(
                  '${steps.indexOf(e) + 1}',
                  style: TextStyle(
                    color: steps.indexOf(e) < provider.step
                        ? Colors.white
                        : AppTheme.textColor1,
                    fontSize: 14,
                  ),
                ),
              ),
              label: Text(e),
              padding: const EdgeInsets.all(0),
              labelStyle: TextStyle(
                color: steps.indexOf(e) < provider.step
                    ? AppTheme.textColor1
                    : AppTheme.borderColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              side: const BorderSide(color: Colors.transparent),
            ),
          )
          .toList(),
    );
  }

  _contentWidgets() {
    return [
      StepOnePage(provider: provider),
      StepTwoPage(provider: provider),
      StepThreePage(provider: provider),
      StepFourPage(provider: provider),
      StepFivePage(provider: provider),
      StepSixPage(provider: provider),
      StepSevenPage(provider: provider),
    ];
  }
}
