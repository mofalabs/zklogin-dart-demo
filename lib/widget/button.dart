import 'package:flutter/material.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';

class ActiveButton extends StatelessWidget {
  final Function? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String data;

  const ActiveButton(
    this.data, {
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed == null
          ? null
          : () {
              onPressed!.call();
            },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.all(18),
        backgroundColor: backgroundColor ?? AppTheme.buttonColor,
        foregroundColor: foregroundColor ?? Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Text(
        data,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  final Function? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final String data;
  final bool enable;

  const BorderButton(
    this.data, {
    super.key,
    this.enable = true,
    this.backgroundColor,
    this.borderColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enable
          ? () {
              onPressed?.call();
            }
          : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.all(18),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Text(
        data,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
