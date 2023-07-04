import 'package:emo_etry_app/widgets/imageCropperWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

Future<String> onCameraTap() async {
  print("Camera tapped");
  final picker = ImagePicker();
  String imagePath = "";

  try {
    final getImage = await picker.pickImage(source: ImageSource.camera);
    if (getImage != null) {
      imagePath = getImage.path;
    } else {
      imagePath = "";
    }
  } catch (e) {
    print("Exception is: " + e.toString());
  }

  return imagePath;
}

Future<String> onGalleryTap() async {
  print("Gallery tapped");
  final picker = ImagePicker();
  String imagePath = "";

  try {
    final getImage = await picker.pickImage(source: ImageSource.gallery);
    if (getImage != null) {
      imagePath = getImage.path;
    } else {
      imagePath = "";
    }
  } catch (e) {
    print("Exception is:" + e.toString());
  }

  return imagePath;
}

modalSheet(BuildContext context) {
  String imagePath = "";
  return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  imagePath = await onCameraTap();
                  if (imagePath.isNotEmpty) {
                    print("ImagePath:" + imagePath.toString());
                    imageCropperFunction(imagePath, context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(15),
                    color: const Color(0xFF1CF0D8),
                  ),
                  child: Text(
                    'Camera',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () async {
                    imagePath = await onGalleryTap();
                    if (imagePath.isNotEmpty) {
                      print("ImagePath: " + imagePath.toString());
                      imageCropperFunction(imagePath, context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(15),
                      color: const Color(0xFF1CF0D8),
                    ),
                    child: Text(
                      'Gallery',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  )),
            ],
          ),
        );
      });
}
