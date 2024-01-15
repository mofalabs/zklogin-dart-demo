import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sui/sui_account.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/util/extension.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';

class StepOnePage extends StatelessWidget {
  SuiAccount? account;

  final Function createClick;
  final Function clearClick;

  StepOnePage({
    super.key,
    this.account,
    required this.clearClick,
    required this.createClick,
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
          const Text(
            'Step 1: Generate Ephemeral Key Pair',
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
          Row(
            children: [
              _createButtonView(),
              const SizedBox(width: 15),
              _clearButtonView(),
            ],
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

  _createButtonView() {
    return ElevatedButton(
      onPressed: account == null
          ? () {
              createClick.call();
            }
          : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.all(18),
        backgroundColor:
            account == null ? AppTheme.buttonColor : AppTheme.unClickColor,
        foregroundColor: account == null
            ? AppTheme.clickTextColor
            : AppTheme.unClickTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: const Text(
        'Create random ephemeral KeyPair',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  _clearButtonView() {
    return ElevatedButton(
      onPressed: account != null
          ? () {
              clearClick.call();
            }
          : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.all(18),
        backgroundColor:
            account == null ? AppTheme.unClickColor : AppTheme.clickColor,
        foregroundColor: account == null
            ? AppTheme.unClickTextColor
            : AppTheme.clickTextColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: const Text(
        'Clear ephemeral KeyPair',
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
