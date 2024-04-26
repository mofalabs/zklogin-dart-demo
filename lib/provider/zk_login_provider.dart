import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sui/sui.dart';
import 'package:sui/types/faucet.dart';
import 'package:zklogin/zklogin.dart';

class ZkLoginProvider extends ChangeNotifier {
  final suiClient = SuiClient(SuiUrls.devnet);

  SuiAccount? _account;

  SuiAccount? get account => _account;

  set account(SuiAccount? value) {
    _account = value;
    notifyListeners();
  }

  int _step = 1;

  int get step => _step;

  set step(int value) {
    _step = value;
    notifyListeners();
  }

  int _maxEpoch = 0;

  int get maxEpoch => _maxEpoch;

  set maxEpoch(int value) {
    _maxEpoch = value;
    notifyListeners();
  }

  String _randomness = '';

  String get randomness => _randomness;

  set randomness(String value) {
    _randomness = value;
    notifyListeners();
  }

  String _nonce = '';

  String get nonce => _nonce;

  set nonce(String value) {
    _nonce = value;
    notifyListeners();
  }

  String _salt = '';

  String get salt => _salt;

  set salt(String value) {
    _salt = value;
    notifyListeners();
  }

  String _address = '';

  String get address => _address;

  set address(String value) {
    _address = value;
    // notifyListeners();
  }

  String _extendedEphemeralPublicKey = '';

  String get extendedEphemeralPublicKey => _extendedEphemeralPublicKey;

  set extendedEphemeralPublicKey(String value) {
    _extendedEphemeralPublicKey = value;
    notifyListeners();
  }

  BigInt? _balance;

  BigInt? get balance => _balance;

  set balance(BigInt? value) {
    _balance = value;
    notifyListeners();
  }

  bool _requesting = false;

  bool get requesting => _requesting;

  set requesting(bool value) {
    _requesting = value;
    notifyListeners();
  }

  String googleIdToken = '';

  getCurrentEpoch() async {
    final result = await suiClient.getLatestSuiSystemState();
    maxEpoch = int.parse(result.epoch);
  }

  /// Sign in with Apple

  String _jwt = '';

  String get jwt => _jwt;

  set jwt(String value) {
    _jwt = value;
    notifyListeners();
  }

  String _userIdentifier = '';

  String get userIdentifier => _userIdentifier;

  set userIdentifier(String value) {
    _userIdentifier = value;
    notifyListeners();
  }

  String _email = '';

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  Map _zkProof = {};

  Map get zkProof => _zkProof;

  set zkProof(Map value) {
    _zkProof = value;
    notifyListeners();
  }

  getBalance() {
    if (address.isNotEmpty) {
      suiClient.getBalance(address).then((res) {
        balance = res.totalBalance;
      });
    }
  }

  void requestFaucet(BuildContext context) async {
    if (requesting) return;
    var resp = await suiClient.getBalance(address);
    balance = resp.totalBalance;
    if (balance! <= BigInt.zero) {
      requesting = true;
      try {
        final faucet = FaucetClient(SuiUrls.faucetDev);
        final faucetResp = await faucet.requestSuiFromFaucetV1(address);
        if (faucetResp.task != null) {
          while (true) {
            final statusResp =
                await faucet.getFaucetRequestStatus(faucetResp.task!);
            if (statusResp.status.status == BatchSendStatus.SUCCEEDED) {
              break;
            } else {
              await Future.delayed(const Duration(seconds: 3));
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.toString());
        }
      } finally {
        requesting = false;
      }
    }

    resp = await suiClient.getBalance(address);
    balance = resp.totalBalance;
  }

  void showSnackBar(BuildContext context, String title, {int seconds = 3}) {
    Flushbar(
      icon: const Icon(Icons.info_outline),
      message: title,
      duration: Duration(seconds: seconds),
    ).show(context);
  }

  getZkProof(BuildContext context) async {
    if (requesting) return;
    requesting = true;
    try {
      final param = {
        "jwt": googleIdToken,
        "extendedEphemeralPublicKey": extendedEphemeralPublicKey,
        "maxEpoch": maxEpoch,
        "jwtRandomness": randomness,
        "salt": salt,
        "keyClaimName": "sub",
      };

      final data = await Dio().post(
        'https://prover-dev.mystenlabs.com/v1',
        data: param,
      );
      zkProof = data.data;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), seconds: 6);
      }
    } finally {
      requesting = false;
    }
  }
}
