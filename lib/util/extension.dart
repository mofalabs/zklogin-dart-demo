import 'dart:convert';
import 'dart:typed_data';

import 'package:sui/utils/hex.dart';

extension Unit8ListExtension on Uint8List {
  String toBase64() {
    return base64Encode(this);
  }

  String toHex() {
    return Hex.encode(this);
  }
}
