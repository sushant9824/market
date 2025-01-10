import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>(
    (ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?> {
  ImageProvider(super.state);

  void imagePick(bool isCamera) async {
    final ImagePicker _picker = ImagePicker();
    if (isCamera) {
      state = await _picker.pickImage(source: ImageSource.camera);
    } else {
      state = await _picker.pickImage(source: ImageSource.gallery);
    }
  }
}

// final randomNumbProvider =
//     StateNotifierProvider((ref) => RandomNumberProvider(0));

// class RandomNumberProvider extends StateNotifier<int> {
//   RandomNumberProvider(super.state);

//   int randomNumb() {
//     int regenerateRandomNum = Random().nextInt(900000) + 100000;
//     return regenerateRandomNum;
//   }
// }
