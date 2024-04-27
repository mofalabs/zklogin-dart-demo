import 'package:flutter/material.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';
import 'package:zklogin/address.dart';

class StepFivePage extends StatefulWidget {
  final ZkLoginProvider provider;

  const StepFivePage({
    super.key,
    required this.provider,
  });

  @override
  State<StepFivePage> createState() => _StepFivePageState();
}

class _StepFivePageState extends State<StepFivePage> {
  ZkLoginProvider get provider => widget.provider;

  final texts = [
    "The user's Sui address is determined by",
    "sub",
    ",",
    "iss",
    ",",
    "aud",
    "and",
    "user_salt",
    "together. For the same JWT,",
    "sub",
    ",",
    "iss",
    ",",
    "and",
    "aud",
    "will not change with each login.",
  ];

  final _indexes = [1, 3, 5, 7];

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
                enable: provider.address.isNotEmpty,
                onPressed: () {
                  provider.step = provider.step + 1;
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            "Step 5: Generate User's Sui Address",
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildTexts(),
          _code(),
          _buttonWidget(),
          const SizedBox(height: 15),
          _addressWidget(),
          const SizedBox(height: 15),
          _balanceWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _code() {
    return const Markdown(
      '```dart\n'
      '${"import 'package:zklogin/zklogin.dart';"}\n\n'
      '/// [jwt] google id_token\n'
      'var address = jwtToAddress(jwt, BigInt.parse(salt));\n'
      '\n```',
    );
  }

  _addressWidget() {
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: [
        _text('User Sui Address: '),
        if (provider.address.isNotEmpty) _text2(provider.address),
      ],
    );
  }

  _balanceWidget() {
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: [
        _text('Balance: '),
        if (provider.address.isNotEmpty)
          _text2(
            '${(provider.balance ?? BigInt.zero) / BigInt.from(10).pow(9)} SUI',
          ),
      ],
    );
  }

  _buttonWidget() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        ActiveButton(
          'Generate Sui Address',
          onPressed: provider.address.isNotEmpty
              ? null
              : () {
                  provider.address = jwtToAddress(
                    provider.googleIdToken,
                    BigInt.parse(provider.salt),
                  );
                  provider.getBalance();
                },
        ),
        ActiveButton(
          provider.requesting ? 'Requesting' : 'Request Test SUI Token',
          onPressed: provider.address.isEmpty
              ? null
              : () {
                  provider.requestFaucet(context);
                },
        ),
      ],
    );
  }

  _buildTexts() {
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: texts.map((value) {
        var index = texts.indexOf(value);
        return _indexes.contains(index) ? _text2(value) : _text(value, true);
      }).toList(),
    );
  }

  Widget _text(text, [bool needPadding = false]) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: needPadding ? 2 : 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textColor2,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _text2(text) {
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
