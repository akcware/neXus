import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0, adapterName: 'UserAdapter')
class User {
  User({this.id, this.deviceId, this.deviceIdHashed, this.name, this.picture});

  @HiveField(0)
  String? id;
  @HiveField(1)
  String? deviceId;
  @HiveField(2)
  String? deviceIdHashed;
  @HiveField(3)
  String? name;
  @HiveField(4)
  Uint8List? picture;

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceId": deviceId,
        "deviceIdHashed": deviceIdHashed,
        "name": name,
        "picture": picture,
      };

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"] as String,
        deviceId = json["deviceId"] as String,
        deviceIdHashed = json["deviceIdHashed"] as String,
        name = json["name"] as String,
        picture = json["picture"] as Uint8List;
}
