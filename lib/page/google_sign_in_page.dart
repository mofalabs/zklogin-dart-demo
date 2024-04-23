import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GoogleSignInPage extends StatefulWidget {
  final String nonce;
  final String idToken;

  const GoogleSignInPage({
    super.key,
    required this.nonce,
    required this.idToken,
  });

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  bool isLoading = false;
  String redirectUrl = 'https%3A%2F%2Fmofalabs.com';
  String replaceUrl = 'https://mofalabs.com/#id_token=';
  var clientId =
      '953150391626-q6id9af1j52h14lu226d7n40lrgrnbj7.apps.googleusercontent.com';

  var url = '';

  @override
  void initState() {
    super.initState();
    url = 'https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?'
        'client_id=$clientId&response_type=id_token&redirect_uri=$redirectUrl'
        '&scope=openid&nonce=${widget.nonce}&service=lso&o2v=2&theme=mn&ddm=0'
        '&flowName=GeneralOAuthFlow&id_token=${widget.idToken}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign In')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
          userAgent: 'Mofa Web3',
          allowsInlineMediaPlayback: true,
          allowsBackForwardNavigationGestures: true,
          automaticallyAdjustsScrollIndicatorInsets: true,
          contentInsetAdjustmentBehavior:
              ScrollViewContentInsetAdjustmentBehavior.ALWAYS,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url;
          if (uri.toString().startsWith(replaceUrl)) {
            String temp = uri.toString().replaceAll(replaceUrl, '');
            temp = temp.substring(0, temp.indexOf('&'));
            Navigator.pop(context, temp);
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          );
        },
      ),
    );
  }
}
