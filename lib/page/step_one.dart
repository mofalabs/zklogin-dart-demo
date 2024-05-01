import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sui/cryptography/ed25519_keypair.dart';
import 'package:sui/sui_account.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/util/extension.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';

class StepOnePage extends StatelessWidget {
  final ZkLoginProvider provider;

  SuiAccount? get account => provider.account;

  const StepOnePage({
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
              const BorderButton('Back', enable: false),
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
            'Step 1: Generate Ephemeral Key Pair',
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            runSpacing: 0,
            children: [
              const Text(
                'The ephemeral key pair is used to sign the ',
                style: TextStyle(
                  color: AppTheme.textColor2,
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
              color: AppTheme.textColor2,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          _buttonView(),
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
    var data = {"schema": "Ed25519", "privateKey": privateKey};
    return const JsonEncoder.withIndent(' ').convert(data);
  }

  _getPublicKey() {
    if (account == null) return 'undefined';
    var publicKey = account!.getPublicKey().toBase64();
    return jsonEncode(publicKey);
  }

  _buttonView() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        ActiveButton(
          'Create random ephemeral KeyPair',
          backgroundColor:
              account == null ? AppTheme.buttonColor : AppTheme.unClickColor,
          foregroundColor: account == null
              ? AppTheme.clickTextColor
              : AppTheme.unClickTextColor,
          onPressed: account == null
              ? () {
                  provider.account = SuiAccount(Ed25519Keypair());
                }
              : null,
        ),
        ActiveButton(
          'Clear ephemeral KeyPair',
          backgroundColor:
              account == null ? AppTheme.unClickColor : AppTheme.clickColor,
          foregroundColor: account == null
              ? AppTheme.unClickTextColor
              : AppTheme.clickTextColor,
          onPressed: account != null
              ? () {
                  provider.account = null;
                }
              : null,
        ),
      ],
    );
  }
}
