import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zklogin_dart_demo/common/theme.dart';
import 'package:zklogin_dart_demo/provider/zk_login_provider.dart';
import 'package:zklogin_dart_demo/widget/button.dart';
import 'package:zklogin_dart_demo/widget/mark_down.dart';
import 'package:zklogin/address.dart';

class StepThreePage extends StatefulWidget {
  final ZkLoginProvider provider;

  const StepThreePage({
    super.key,
    required this.provider,
  });

  @override
  State<StepThreePage> createState() => _StepThreePageState();
}

class _StepThreePageState extends State<StepThreePage> {
  ZkLoginProvider get provider => widget.provider;

  String get jwt => provider.jwt;

  @override
  void initState() {
    super.initState();
  }

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
                enable: provider.jwt.isNotEmpty,
                onPressed: () {
                  provider.step = provider.step + 1;
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Step 3: Decode JWT (needed for assembling zkLogin signature later)',
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Color(0xFFECEFF1),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('// JWT'),
                const SizedBox(height: 5),
                Text(
                  jwt,
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.green.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Decode JWT Payload',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Markdown(
            '```dart\n'
            '${"import 'package:sui/sui.dart';"}\n\n'
            'Map jwt = decodeJwt(jwt);\n'
            '\n```',
          ),
          const Text(
            'JWT Payload',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Markdown(
            '```json \n'
            '${jwt.isNotEmpty ? const JsonEncoder.withIndent('  ').convert(decodeJwt(jwt)) : ''}\n'
            '\n```',
          ),
        ],
      ),
    );
  }
}
