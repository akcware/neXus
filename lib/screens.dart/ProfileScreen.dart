import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexus/models/user.dart';
import 'package:nexus/utils/user_encryption.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  User? user;
  String qrString = "";
  final textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
              child: Column(children: [
                const SizedBox(height: 16),
                Text(
                  "Scan the Qr Code",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Card(
                  child: QrImageView(
                    data: qrString,
                    version: QrVersions.auto,
                    size: 300.0,
                  ),
                ),
                const Text("Or send these codes: "),
                TextField(
                  controller: textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  minLines: 2,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefix: IconButton(
                      icon: const Icon(EvaIcons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: qrString));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                "Codes are copied. You can send to your friends."),
                            action: Platform.isLinux
                                ? null
                                : SnackBarAction(
                                    label: "Share",
                                    onPressed: () {
                                      Share.share(qrString);
                                    },
                                  ),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ]),
            ),
    );
  }

  void initializeUser() async {
    final box = await Hive.openBox("root");
    user = box.get("user");

    user!.deviceId = null;

    setState(() {
      qrString = userEncrypt(user!);
      textEditingController.text = qrString;
    });
  }
}
