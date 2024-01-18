import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sui/sui.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';

class StepTwoPage extends StatelessWidget {
  final ZkLoginProvider provider;

  SuiAccount? get account => provider.account;

  const StepTwoPage({
    super.key,
    required this.provider,
  });

  List get messages => [
        'Required parameters:',
        ['1.', r'$CLIENT_ID', '(Obtained by applying for OpenID Service.)'],
        ['2.', r'$REDIRECT_URL', '(App Url, configured in OpenID Service)'],
        [
          '3.',
          r'$NONCE',
          '(Generated through',
          'ephemeralKeyPair',
          'maxEpoch',
          'randomness',
          ')'
        ],
        [
          '*ephemeralKeyPair',
          ': Ephemeral key pair generated in the previous step'
        ],
        ['*maxEpoch: ', 'Validity period of the ephemeral key pair'],
        ['*randomness', ': Randomness'],
      ];

  List get messages2 => [
        [
          'Current Epoch: ',
          provider.epoch == '0'
              ? 'Click the button above to obtain'
              : provider.epoch
        ],
        [
          'Assuming the validity period is set to 10 Epochs, then:',
          'maxEpoch: ${provider.epoch}'
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
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
          Column(children: messages.map((e) => _getRowTexts(e)).toList()),
          const SizedBox(height: 15),
          ActiveButton(
            'Fetch current Epoch (via Sui Client)',
            onPressed: () {
              provider.getCurrentEpoch();
            },
          ),
          const SizedBox(height: 15),
          Column(
              children:
                  messages2.map((e) => _getRowTexts(e, right: true)).toList()),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              ActiveButton(
                'Generate randomness',
                onPressed: () {},
              ),
              const SizedBox(width: 15),
              _text2(
                'randomness: ${provider.randomness}',
                bottom: 0,
                top: 9,
              ),
            ],
          ),
          const SizedBox(height: 30),
          _googleWidget(),
        ],
      ),
    );
  }

  _googleWidget() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.all(18),
        backgroundColor: AppTheme.buttonColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/google.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 15),
            const Text(
              'Sign In With Google',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  Widget _getRowTexts(messages, {bool right = false}) {
    if (messages is String) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [_text1(messages)]),
      );
    } else {
      List<Widget> list = [];

      messages as List;
      if (messages.length == 2) {
        if (right) {
          list.add(_text1(messages[0]));
          list.add(_text2(messages[1]));
        } else {
          list.add(_text2(messages[0]));
          list.add(_text1(messages[1]));
        }
      } else if (messages.length == 3) {
        list.add(_text1(messages[0]));
        list.add(_text2(messages[1]));
        list.add(_text1(messages[2]));
      } else {
        list.add(_text1(messages[0]));
        list.add(_text2(messages[1]));
        list.add(_text1(messages[2]));
        list.add(_text2(messages[3]));
        list.add(_text2(messages[4]));
        list.add(_text2(messages[5]));
        list.add(_text1(messages[6]));
      }
      return Container(
        alignment: Alignment.topLeft,
        child: Wrap(
          children: list,
        ),
      );
    }
  }

  _text1(text) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textColor1,
          fontSize: 15,
        ),
      ),
    );
  }

  _text2(text, {double bottom = 10, double top = 0}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      margin: EdgeInsets.only(right: 5, bottom: bottom, top: top),
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
