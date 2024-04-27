import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';
import 'package:zklogin/zklogin.dart';

class StepSixPage extends StatefulWidget {
  final ZkLoginProvider provider;

  const StepSixPage({
    super.key,
    required this.provider,
  });

  @override
  State<StepSixPage> createState() => _StepSixPageState();
}

class _StepSixPageState extends State<StepSixPage> {
  ZkLoginProvider get provider => widget.provider;

  var texts = [
    "This is the proof (ZK Proof) for the ephemeral key pair.",
    "1. First, generate the extended ephemeral public key as input for the ZKP.",
    "2. Use the generated extended ephemeral public key (extendedEphemeralPublicKey) "
        "to generate ZK Proof. SUI provides a backend service."
  ];

  @override
  Widget build(BuildContext context) {
    return _contentView();
  }

  _contentView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BorderButton(
                'Back',
                onPressed: () {
                  provider.step = provider.step - 1;
                },
              ),
              const SizedBox(width: 15),
              BorderButton(
                'Next',
                enable: provider.zkProof.keys.isNotEmpty,
                onPressed: () {
                  provider.step = provider.step + 1;
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Step 6: Fetch ZK Proof (Groth16)',
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _text(texts[0], height: 2),
          const SizedBox(height: 10),
          _text(texts[1], height: 2),
          _code1(),
          ActiveButton(
            'Generate the extended ephemeral public key',
            onPressed: () {
              provider.extendedEphemeralPublicKey =
                  getExtendedEphemeralPublicKey(
                provider.account!.keyPair.getPublicKey(),
              );
            },
          ),
          const SizedBox(height: 15),
          _publicKeyWidget(),
          const SizedBox(height: 20),
          _text(texts[2], height: 2),
          _code2(),
          ActiveButton(
            provider.requesting ? 'Fetching' : 'Fetch ZK Proof',
            onPressed: provider.extendedEphemeralPublicKey.isNotEmpty
                ? () {
                    provider.getZkProof(context);
                  }
                : null,
          ),
          if (provider.zkProof.isNotEmpty)
            Markdown(
              '```json \n'
              '${const JsonEncoder.withIndent('  ').convert(provider.zkProof)}\n'
              '\n```',
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  _publicKeyWidget() {
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: [
        _text('extendedEphemeralPublicKey: ', needPadding: true),
        if (provider.extendedEphemeralPublicKey.isNotEmpty)
          _colorText(provider.extendedEphemeralPublicKey),
      ],
    );
  }

  _code1() {
    return const Markdown(
      '```dart\n'
      '${"import 'package:zklogin/zklogin.dart';"}\n\n'
      'var extendedEphemeralPublicKey = getExtendedEphemeralPublicKey(ephemeralKeyPair.getPublicKey();\n'
      '\n```',
    );
  }

  _code2() {
    return const Markdown(
      '```dart\n'
      '${"import 'package:dio/dio.dart';"}\n\n'
      'getZkProof() async {\n'
      '    final body = {\n'
      '        "jwt": googleIdToken,\n'
      '        "extendedEphemeralPublicKey": extendedEphemeralPublicKey,\n'
      '        "maxEpoch": maxEpoch,\n'
      '        "jwtRandomness": randomness,\n'
      '        "salt": salt,\n'
      '        "keyClaimName": "sub",\n'
      '    };\n'
      '    final zkProof = await Dio().post("https://prover-dev.mystenlabs.com/v1", data: body);\n'
      '    return zkProof.data;\n'
      '}\n'
      '\n```',
    );
  }

  Widget _text(text, {bool needPadding = false, double? height}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: needPadding ? 2 : 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.textColor2,
          fontSize: 15,
          height: height,
        ),
      ),
    );
  }

  Widget _colorText(text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      margin: const EdgeInsets.only(right: 5),
      color: const Color(0xFFFFEDCF),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textColor1,
          fontSize: 15,
        ),
      ),
    );
  }
}
