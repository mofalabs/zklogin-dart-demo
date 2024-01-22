import 'package:flutter/material.dart';
import 'package:sui/sui.dart';

class ZkLoginProvider extends ChangeNotifier {
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

  int _epoch = 0;

  int get epoch => _epoch;

  set epoch(int value) {
    _epoch = value;
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

  getCurrentEpoch() async {
    final result =
        await SuiClient(Constants.devnetAPI).getLatestSuiSystemState();
    epoch = int.parse(result.epoch);
  }
}
