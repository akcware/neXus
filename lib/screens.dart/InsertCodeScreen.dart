import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

class InsertCodeScreen extends StatefulWidget {
  const InsertCodeScreen({super.key});

  @override
  State<InsertCodeScreen> createState() => _InsertCodeScreenState();
}

class _InsertCodeScreenState extends State<InsertCodeScreen> {
  final _textEditingController = TextEditingController();
  bool isScanningMode = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Add Friend",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter code",
                    suffix: IconButton(
                      icon: const Icon(EvaIcons.codeDownload),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                  ),
                  controller: _textEditingController,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (Platform.isAndroid || Platform.isMacOS || Platform.isIOS) ...[
              Text(
                "Or",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isScanningMode = true;
                  });
                },
                icon: const Icon(EvaIcons.cameraOutline),
                label: const Text(
                  "Scan Qr Code",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            // if (isScanningMode)
            // MobileScanner(
            //   fit: BoxFit.contain,
            // ),
          ],
        ),
      ),
    );
  }
}
