import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexus/models/user.dart';
import 'package:nexus/screens.dart/Root.dart';
import 'package:uuid/uuid.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initializeUser();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const RootScreen(
        title: "neXus",
      ),
    );
  }
}

void initializeUser() async {
  var box = await Hive.openBox("root");

  if (box.get("user") == null) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "";
    if (Platform.isAndroid) {
      final AndroidDeviceInfo info = await deviceInfo.androidInfo;

      deviceId = info.id;
    } else if (Platform.isIOS) {
      // TODO: IOS Device Id
    } else if (Platform.isWindows) {
      // TODO: Windows Device Id
    } else if (Platform.isLinux) {
      final LinuxDeviceInfo info = await deviceInfo.linuxInfo;
      final machineId = info.machineId;

      if (machineId == null) throw "MACHINE_ID_NULL";
      deviceId = machineId;
    } else if (Platform.isMacOS) {
    } else if (kIsWeb) {
      final WebBrowserInfo info = await deviceInfo.webBrowserInfo;

      deviceId =
          info.vendor! + info.userAgent! + info.hardwareConcurrency.toString();
      final deviceidInbytes = utf8.encode(deviceId);
      deviceId = sha256.convert(deviceidInbytes).toString();
    }

    final deviceIdHashed = sha256.convert(utf8.encode(deviceId)).toString();

    const uuid = Uuid();
    final user = User(
      id: uuid.v4(),
      name: "",
      deviceId: deviceId,
      deviceIdHashed: deviceIdHashed,
      picture: Uint8List.fromList([]),
    );

    box.put("user", user);
  }

  final User n = box.get("user");
  print("Id: ${n.id}");
  print("DeviceId: ${n.deviceId}");
  print("DeviceIdHashed: ${n.deviceIdHashed}");
  print("Name: ${n.name}");
}
