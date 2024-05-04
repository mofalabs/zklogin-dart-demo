import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:zklogin_dart_demo/data/constants.dart';
import 'package:zklogin_dart_demo/provider/zk_login_provider.dart';

class GoogleSignInPage extends StatefulWidget {
  final ZkLoginProvider provider;

  const GoogleSignInPage({
    super.key,
    required this.provider,
  });

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  ZkLoginProvider get provider => widget.provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign In')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(provider.googleLoginUrl)),
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
          if (uri.toString().startsWith(Constant.website)) {
            if (uri.toString().startsWith(Constant.replaceUrl)) {
              String temp = uri.toString().replaceAll(Constant.replaceUrl, '');
              temp = temp.substring(0, temp.indexOf('&'));
              Navigator.pop(context, temp);
            } else {
              Navigator.pop(context);
            }
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
