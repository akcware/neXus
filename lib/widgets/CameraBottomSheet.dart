import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraBottomSheet extends StatefulWidget {
  const CameraBottomSheet({super.key, required this.cams});

  final List<CameraDescription> cams;

  @override
  State<CameraBottomSheet> createState() => _CameraBottomSheetState();
}

class _CameraBottomSheetState extends State<CameraBottomSheet> {
  late CameraController _controller;
  bool isRearCam = true;
  bool showCapturedPhoto = false;
  late Image image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera(widget.cams[0]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return showCapturedPhoto ? showTakenPicture() : showCamera(deviceRatio);
  }

  ClipRRect showCamera(double deviceRatio) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _controller.value.isInitialized
                ? Transform.scale(
                    scale: _controller.value.aspectRatio / deviceRatio,
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Center(child: CameraPreview(_controller))),
                  )
                : const Center(child: Text("Loading Camera")),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.image_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera),
                            iconSize: 48,
                            color: Colors.white,
                            onPressed: onCaptureButtonPressed,
                          ),
                          IconButton(
                            icon: const Icon(Icons.cameraswitch),
                            onPressed: () {
                              setState(() {
                                isRearCam = !isRearCam;
                                initCamera(widget.cams[isRearCam ? 0 : 1]);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showTakenPicture() {
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
                        icon: const Icon(EvaIcons.close),
                        iconSize: 32,
                        onPressed: () {
                          setState(() {
                            showCapturedPhoto = false;
                          });
                          if (kIsWeb) {
                            _controller.dispose().then((_) {
                              initCamera(widget.cams[isRearCam ? 0 : 1]);
                            });
                          }
                        },
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
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

  Future initCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.max);
    try {
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  void onCaptureButtonPressed() async {
    //on camera button press
    try {
      if (!kIsWeb) _controller.setFlashMode(FlashMode.off);
      final file = await _controller.takePicture();

      if (kIsWeb) {
        image = Image.network(file.path);
      } else {
        image = Image.file(File(file.path));
      }
      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
