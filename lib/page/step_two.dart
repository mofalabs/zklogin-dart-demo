import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/util/extension.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';

class StepTwoPage extends StatelessWidget {
  final ZkLoginProvider provider;

  SuiAccount? get account => provider.account;

  const StepTwoPage({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
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
                enable: account != null,
                onPressed: () {
                  provider.step = provider.step + 1;
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Step 2: Fetch JWT (from OpenID Provider)',
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Text(
                'The ephemeral key pair is used to sign the ',
                style: TextStyle(
                  color: AppTheme.textColor1,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                color: const Color(0xFFFFEDCF),
                child: const Text(
                  'TransactionBlock',
                  style: TextStyle(
                    color: AppTheme.textColor1,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Stored in the browser session. (Session Storage)',
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          ActiveButton(
            'Fetch current Epoch (via Sui Client)',
            onPressed: () {},
          ),
          ActiveButton(
            'Generate randomness',
            onPressed: () {},
          ),
          ActiveButton(
            'Generate randomness',
            onPressed: () {},
          ),
          Markdown(
            '```dart\n'
            '// PrivateKey\n'
            '${_getPrivateKey()}'
            '\n```',
          ),
          Container(
            transform: Matrix4.translationValues(0, -20, 0),
            child: Markdown(
              '```\n'
              '// PublicKey\n'
              '${_getPublicKey()}'
              '\n```',
            ),
          )
        ],
      ),
    );
  }

  _getPrivateKey() {
    if (account == null) return 'undefined';
    var privateKey = account!.getSecretKey().sublist(0, 32).toBase64();
    var data = {"schema": "ED25519", "privateKey": privateKey};
    return const JsonEncoder.withIndent(' ').convert(data);
  }

  _getPublicKey() {
    if (account == null) return 'undefined';
    var publicKey = account!.getPublicKey().toBase64();
    return jsonEncode(publicKey);
  }
}
