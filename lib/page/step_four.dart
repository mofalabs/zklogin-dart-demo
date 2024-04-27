import 'package:flutter/material.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';
import 'package:zklogin/zklogin.dart';

class StepFourPage extends StatefulWidget {
  final ZkLoginProvider provider;

  const StepFourPage({
    super.key,
    required this.provider,
  });

  @override
  State<StepFourPage> createState() => _StepFourPageState();
}

class _StepFourPageState extends State<StepFourPage> {
  ZkLoginProvider get provider => widget.provider;

  @override
  void initState() {
    super.initState();
    if (provider.salt.isEmpty) {
      WidgetsBinding
      .instance
      .addPostFrameCallback((_){ 
          provider.salt = generateRandomness();
      });
    }
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
                enable: provider.salt.isNotEmpty,
                onPressed: () {
                  provider.step = provider.step + 1;
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            "Step 4: Generate User's Salt",
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: _text(
              'User Salt is used to eliminate the one-to-one correspondence '
              'between the OAuth identifier (sub) and the on-chain Sui address, '
              'avoiding linking Web2 credentials with Web3 credentials.',
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 15),
            color: const Color(0xFFFFEDCF),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFF513500),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Therefore, it is essential to safeguard the Salt. If lost, "
                    "users won't be able to recover the address generated with the current Salt.",
                    style: TextStyle(
                      color: Color(0xFF513500),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _text(
            'Where to Save:\n\n'
            "1. Ask the user to remember (send to user's email)\n\n"
            '2. Store on the client side (browser)\n\n'
            '3. Save in the APP Backend database, corresponding one-to-one with UID\n',
          ),
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            runSpacing: 15,
            spacing: 15,
            children: [
              ActiveButton(
                'Generate User Salt',
                onPressed: provider.salt.isNotEmpty
                    ? null
                    : () {
                        provider.salt = generateRandomness();
                      },
              ),
              ActiveButton(
                'Delete User Salt',
                backgroundColor: Colors.red,
                onPressed: provider.salt.isEmpty
                    ? null
                    : () {
                        provider.salt = '';
                      },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            runSpacing: 15,
            spacing: 5,
            children: [
              _text('User Salt: ', true),
              if (provider.salt.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.only(right: 5),
                  color: const Color(0xFFFFEDCF),
                  child: Text(
                    provider.salt,
                    style: const TextStyle(
                      color: AppTheme.textColor1,
                      fontSize: 15,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Code",
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Markdown(
            '```dart\n'
            '${"import 'package:zklogin/zklogin.dart';"}\n\n'
            'var salt = generateRandomness();\n'
            '\n```',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _text(text, [bool needPadding = false]) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: needPadding ? 5 : 0,
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
}
