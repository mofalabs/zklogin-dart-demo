import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';

class StepFivePage extends StatelessWidget {
  final ZkLoginProvider provider;

  SuiAccount? get account => provider.account;

  const StepFivePage({
    super.key,
    required this.provider,
  });

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
                enable: account != null,
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
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
