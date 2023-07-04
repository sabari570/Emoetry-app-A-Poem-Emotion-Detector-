import 'package:emo_etry_app/screens/functionality/homeScreen.dart';
import 'package:emo_etry_app/screens/functionality/poemInputPage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

void imageCropperFunction(String imagePath, BuildContext context) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  );

  if (croppedFile != null) {
    print("Image cropped!!");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomePage(imagePath: croppedFile.path);
    }), (route) => false);
  } else {
    print("Image not cropped!");
  }
}
