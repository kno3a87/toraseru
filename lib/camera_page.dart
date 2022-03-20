import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Camera(camera: camera),
    );
  }
}

class Camera extends StatefulWidget {
  const Camera({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _cameraController;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.bgra8888, // iOS
    );
    _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  takePicture2() async {
    if (_cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final file = await _cameraController.takePicture();
      setState(() {
        imageFile = file;
      });
      final Uint8List buffer = await file.readAsBytes();
      await ImageGallerySaver.saveImage(buffer, name: file.name);
      debugPrint('Picture saved to ${file.path}');
    } on CameraException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const SizedBox.shrink();
    }
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Center(
          child: CameraPreview(_cameraController),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(imageFile.toString()),
            IconButton(
              onPressed: () async {
                await takePicture2();
              },
              icon: const Icon(
                Icons.camera,
                size: 44.0,
                semanticLabel: 'Take Picture',
              ),
            ),
          ],
        )
      ],
    );
  }
}
