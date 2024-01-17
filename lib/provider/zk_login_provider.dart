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

  String _epoch = '';

  String get epoch => _epoch;

  set epoch(String value) {
    _epoch = value;
    notifyListeners();
  }

  getCurrentEpoch() async {
    final result =
        await SuiClient(Constants.devnetAPI).getLatestSuiSystemState();
    epoch = result.epoch;
  }
}