import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sui/sui.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/page/google_sign_in_page.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';
import 'package:zklogin/zklogin.dart' hide generateNonce;

class StepTwoPage extends StatefulWidget {
  final ZkLoginProvider provider;

  const StepTwoPage({
    super.key,
    required this.provider,
  });

  @override
  State<StepTwoPage> createState() => _StepTwoPageState();
}

class _StepTwoPageState extends State<StepTwoPage> {
  SuiAccount? get account => widget.provider.account;

  bool get click =>
      widget.provider.epoch > 0 && widget.provider.randomness.isNotEmpty;

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
          widget.provider.epoch == 0
              ? 'Click the button above to obtain'
              : '${widget.provider.epoch}'
        ],
        [
          'Assuming the validity period is set to 10 Epochs, then:',
          'maxEpoch: ${widget.provider.epoch == 0 ? widget.provider.epoch : widget.provider.epoch + 10}'
        ],
      ];

  // Google id token
  var idToken = '';

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
                  widget.provider.step = widget.provider.step - 1;
                },
              ),
              const SizedBox(width: 15),
              BorderButton(
                'Next',
                enable: account != null,
                onPressed: () {
                  widget.provider.step = widget.provider.step + 1;
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
              widget.provider.getCurrentEpoch();
            },
          ),
          const SizedBox(height: 15),
          Column(
              children:
                  messages2.map((e) => _getRowTexts(e, right: true)).toList()),
          const Markdown(
            '```dart\n'
            '${"import 'package:sui/sui.dart';"}\n\n'
            '// randomness\n'
            'const randomness = generateRandomness();'
            '\n```',
          ),
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            children: [
              ActiveButton(
                'Generate randomness',
                onPressed: () {
                  widget.provider.randomness = generateRandomness();
                },
              ),
              const SizedBox(width: 15),
              _text2(
                'randomness: ${widget.provider.randomness}',
                bottom: 0,
                top: 9,
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Markdown(
            '```dart\n'
            '${"import 'package:sui/sui.dart';"}\n\n'
            '// Generate Nonce for acquiring JWT\n'
            'const nonce = generateNonce(\n'
            '    ephemeralKeyPair.getPublicKey(),\n'
            '    maxEpoch,\n'
            '    randomness\n'
            ');\n'
            '\n```',
          ),
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            children: [
              ActiveButton(
                'Generate Nonce',
                backgroundColor:
                    click ? AppTheme.buttonColor : AppTheme.unClickColor,
                foregroundColor:
                    click ? AppTheme.clickTextColor : AppTheme.unClickTextColor,
                onPressed: click
                    ? () {
                        widget.provider.nonce = generateNonce();
                        // provider.nonce = generateNonce(
                        //   account!.keyPair.getPublicKey(),
                        //   provider.epoch + 10,
                        //   provider.randomness,
                        // );
                      }
                    : null,
              ),
              const SizedBox(width: 15),
              _text2(
                'nonce: ${widget.provider.nonce}',
                bottom: 0,
                top: 9,
              ),
            ],
          ),
          const SizedBox(height: 30),
          _signInWidget(context),
        ],
      ),
    );
  }

  _signInWidget(
    BuildContext context,
  ) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
      runSpacing: 15,
      children: [
        if (!kIsWeb && Platform.isIOS)
          _signInButton(context, 'apple.svg', 'Apple'),
        _signInButton(context, 'google.svg', 'Google'),
      ],
    );
  }

  _signInButton(BuildContext context, String svg, String name) {
    return ElevatedButton(
      onPressed: () async {
        if (name == 'Apple') {
          final result = await SignInWithApple.getAppleIDCredential(
            scopes: [AppleIDAuthorizationScopes.email],
            nonce: widget.provider.nonce,
          );
          widget.provider.jwt = result.identityToken ?? '';
          widget.provider.userIdentifier = result.userIdentifier ?? '';
          widget.provider.email = result.email ?? '';
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleSignInPage(
                nonce: widget.provider.nonce,
                idToken: idToken,
              ),
            ),
          ).then((value) {
            if (value is String) {
              idToken = value;
            }
          });
        }
      },
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
              'assets/$svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 15),
            Text(
              'Sign in with $name',
              style: const TextStyle(fontSize: 15),
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
