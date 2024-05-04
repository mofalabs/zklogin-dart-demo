import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_macos_webview/flutter_macos_webview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' hide generateNonce;
import 'package:sui/sui.dart';
import 'package:zklogin_dart_demo/common/theme.dart';
import 'package:zklogin_dart_demo/data/constants.dart';
import 'package:zklogin_dart_demo/page/google_sign_in_page.dart';
import 'package:zklogin_dart_demo/provider/zk_login_provider.dart';
import 'package:zklogin_dart_demo/widget/button.dart';
import 'package:zklogin_dart_demo/widget/mark_down.dart';
import 'package:zklogin/zklogin.dart';

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
  ZkLoginProvider get provider => widget.provider;

  SuiAccount? get account => provider.account;

  bool get click => provider.maxEpoch > 0 && provider.randomness.isNotEmpty;

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
          provider.maxEpoch == 0
              ? 'Click the button above to obtain'
              : '${provider.maxEpoch - 10}'
        ],
        [
          'Assuming the validity period is set to 10 Epochs, then:',
          'maxEpoch: ${provider.maxEpoch == 0 ? provider.maxEpoch : provider.maxEpoch}'
        ],
      ];

  FlutterMacOSWebView? macOsWebView;

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
                enable: account != null && provider.jwt.isNotEmpty,
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
            runSpacing: 15,
            spacing: 15,
            children: [
              ActiveButton(
                'Generate randomness',
                onPressed: () {
                  provider.randomness = generateRandomness();
                },
              ),
              _text2(
                'randomness: ${provider.randomness}',
                bottom: 0,
                top: 9,
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Markdown(
            '```dart\n'
            '${"import 'package:zklogin/zklogin.dart';"}\n\n'
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
                        provider.nonce = generateNonce(
                          account!.keyPair.getPublicKey(),
                          provider.maxEpoch,
                          provider.randomness,
                        );
                      }
                    : null,
              ),
              const SizedBox(width: 15),
              _text2(
                'nonce: ${provider.nonce}',
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
      spacing: 15,
      runSpacing: 15,
      children: [
        if (Platform.isIOS || Platform.isMacOS)
          _signInButton(context, 'apple.svg', 'Apple'),
        _signInButton(context, 'google.svg', 'Google'),
      ],
    );
  }

  _signInButton(BuildContext context, String svg, String name) {
    return ElevatedButton(
      onPressed: provider.nonce.isEmpty
          ? null
          : () async {
              if (name == 'Apple') {
                final result = await SignInWithApple.getAppleIDCredential(
                  scopes: [AppleIDAuthorizationScopes.email],
                  nonce: provider.nonce,
                );
                provider.jwt = result.identityToken ?? '';
                provider.userIdentifier = result.userIdentifier ?? '';
                provider.email = result.email ?? '';
              } else {
                Platform.isMacOS
                    ? _showMacOsWeb()
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleSignInPage(
                            provider: provider,
                          ),
                        ),
                      ).then((value) {
                        if (value is String) {
                          provider.jwt = value;
                          provider.step = provider.step + 1;
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

  _showMacOsWeb() async {
    macOsWebView = FlutterMacOSWebView(
      onPageFinished: (url) async {
        if (url.toString().startsWith(Constant.website)) {
          if (url.toString().startsWith(Constant.replaceUrl)) {
            String temp = url!.replaceAll(Constant.replaceUrl, '');
            provider.jwt = temp.substring(0, temp.indexOf('&'));
            macOsWebView?.close();
            provider.step = provider.step + 1;
          } else {
            macOsWebView?.close();
          }
        }
      },
      onWebResourceError: (err) {
        debugPrint(
          'Error: ${err.errorCode}, ${err.errorType}, ${err.domain}, ${err.description}',
        );
      },
    );

    await macOsWebView?.open(
      url: provider.googleLoginUrl,
      presentationStyle: PresentationStyle.sheet,
      size: const Size(900.0, 600.0),
      userAgent: 'Mofa Web3',
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
          color: AppTheme.textColor2,
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
