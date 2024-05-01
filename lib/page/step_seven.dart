import 'package:flutter/material.dart';
import 'package:sui_dart_zklogin_demo/common/theme.dart';
import 'package:sui_dart_zklogin_demo/provider/zk_login_provider.dart';
import 'package:sui_dart_zklogin_demo/widget/button.dart';
import 'package:sui_dart_zklogin_demo/widget/mark_down.dart';
import 'package:url_launcher/url_launcher.dart';

class StepSevenPage extends StatefulWidget {
  final ZkLoginProvider provider;

  const StepSevenPage({
    super.key,
    required this.provider,
  });

  @override
  State<StepSevenPage> createState() => _StepSevenPageState();
}

class _StepSevenPageState extends State<StepSevenPage> {
  ZkLoginProvider get provider => widget.provider;

  final texts = [
    "Each ZK Proof is associated with an ephemeral key pair. Stored in the "
        "appropriate location, it can be reused as proof to sign any number"
        " of transactions until the ephemeral key pair expires.",
    "Before executing the transaction, please recharge zkLogin with a small "
        "amount of SUI as the gas fee for initiating the transaction.",
  ];

  String? digest;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return _contentView();
  }

  _contentView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
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
              const BorderButton(
                'Next',
                enable: false,
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Step 7: Assemble zkLogin signature and submit the transaction',
            style: TextStyle(
              color: AppTheme.textColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _accountAddressWidget(),
          _tipWidget(),
          _text(texts[1]),
          _codeWidget(),
          ActiveButton(
            provider.requesting ? 'Executing' : 'Execute TransactionBlock',
            onPressed: () async {
              digest = await provider.executeTransactionBlock(context);
              setState(() {});
            },
          ),
          if (digest != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _digestWidget(),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _digestWidget() {
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: [
        _text('Digest: '),
        InkWell(
          onTap: () {
            launchUrl(Uri.parse('https://suiscan.xyz/devnet/tx/$digest'));
          },
          child: Text(
            digest ?? '',
            style: const TextStyle(
              color: Color.fromARGB(255, 68, 165, 214),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
    ;
  }

  _tipWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 15),
      color: const Color(0xFFFFEDCF),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFF513500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texts[0],
              style: const TextStyle(
                color: Color(0xFF513500),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _codeWidget() {
    return const Markdown(
      '```dart\n'
      '${"import 'package:sui/sui.dart';"}\n'
      '${"import 'package:zklogin/zklogin.dart';"}\n\n'
      'executeTransactionBlock() async {\n'
      '    final suiClient = SuiClient(SuiUrls.devnet);\n'
      '    final txb = TransactionBlock();\n'
      '    txb.setSenderIfNotSet(address);\n'
      '    final coin = txb.splitCoins(txb.gas, [txb.pureInt(22222)]);\n'
      '    txb.transferObjects([coin], txb.pureAddress(address));\n'
      '    final sign = await txb.sign(\n'
      '        SignOptions(\n'
      '            signer: account!.keyPair,\n'
      '            client: suiClient,\n'
      '        ),\n'
      '    );\n'
      '    final jwtJson = decodeJwt(jwt);\n'
      '    final addressSeed = genAddressSeed(\n'
      '        BigInt.parse(salt),\n'
      '        "sub",\n'
      '        jwtJson["sub"].toString(),\n'
      '        jwtJson["aud"].toString(),\n'
      '    );\n'
      '    zkProof["addressSeed"] = addressSeed.toString();\n'
      '    final zkSign = getZkLoginSignature(\n'
      '        ZkLoginSignature(\n'
      '            inputs: ZkLoginSignatureInputs.fromJson(zkProof),\n'
      '            maxEpoch: maxEpoch,\n'
      '            userSignature: base64Decode(sign.signature),\n'
      '        ),\n'
      '    );\n'
      '    final resp = await suiClient.executeTransactionBlock(\n'
      '        sign.bytes,\n'
      '        [zkSign],\n'
      '        options: SuiTransactionBlockResponseOptions(showEffects: true),\n'
      '    );\n'
      '    return resp.digest;\n'
      '}\n'
      '\n```',
    );
  }

  Widget _text(text, {double? height}) {
    return Text(
      text,
      style: TextStyle(
        color: AppTheme.textColor2,
        fontSize: 15,
        height: height,
      ),
    );
  }

  _accountAddressWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Account',
          style: TextStyle(
            color: AppTheme.textColor1,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _addressWidget(),
        const SizedBox(height: 10),
        _balanceWidget(),
        const SizedBox(height: 20),
      ],
    );
  }

  _addressWidget() {
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: [
        _text('User Sui Address: '),
        if (provider.address.isNotEmpty) _text2(provider.address),
      ],
    );
  }

  _balanceWidget() {
    return Wrap(
      spacing: 3,
      runSpacing: 5,
      children: [
        _text('Balance: '),
        if (provider.address.isNotEmpty)
          _text2(
            '${(provider.balance ?? BigInt.zero) / BigInt.from(10).pow(9)} SUI',
          ),
      ],
    );
  }

  Widget _text2(text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      margin: const EdgeInsets.only(right: 5),
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
