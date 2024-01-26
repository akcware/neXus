import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/ui/NxsTap.dart';
import 'package:nexus/widgets/CameraBottomSheet.dart';
import 'package:nexus/widgets/MessageBubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  int itemCount = 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: NxsTap(
          useRipple: false,
          onTap: Navigator.of(context).pop,
          borderRadius: BorderRadius.circular(90),
          child: const SizedBox.shrink(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(EvaIcons.arrowIosBack),
                CircleAvatar(),
              ],
            ),
          ),
        ),
        leadingWidth: 90,
        title: const Text("Emre Toykalan"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(EvaIcons.videoOutline), onPressed: () {}),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: itemCount,
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 100),
              itemBuilder: (ctx, i) {
                // TODO: LAZY INFINITE SCROLL
                return MessageBubble(
                  text: "This is a great $i. message.",
                  isReceived: Random().nextBool(),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      if (Platform.isLinux ||
                          Platform.isMacOS ||
                          Platform.isWindows) {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (image == null) return;
                        final imgMemory =
                            Image.memory(await image!.readAsBytes());
                        showModalBottomSheet(
                            context: context,
                            builder: (_) => showTakenPicture(imgMemory));

                        return;
                      }
                      availableCameras().then((cams) {
                        showModalBottomSheet(
                            context: context,
                            constraints: BoxConstraints.loose(
                              Size(MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height * 0.85),
                            ),
                            isScrollControlled: true,
                            builder: (_) => CameraBottomSheet(cams: cams));
                      });
                    },
                    icon: const Icon(Icons.photo_camera),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                            hintText: "Write message",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.keyboard_arrow_right),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showTakenPicture(Image image) {
    return SizedBox.expand(
      child: Stack(
        children: [
          image,
          Positioned(
            right: 8,
            bottom: 64,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8,
                    sigmaY: 8,
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          // await Gal.putImage(imagePath);
                        },
                        iconSize: 32,
                        color: Colors.white,
                        icon: const Icon(EvaIcons.arrowRightOutline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
