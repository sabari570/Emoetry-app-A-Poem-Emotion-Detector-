import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF000113),
      body: Center(
        child: SpinKitFoldingCube(
          color: Color(0xFF1CF0D8),
          size: 50.0,
        ),
      ),
    );
  }
}

Widget imageLoadingAnimation() {
  return const Center(
    child: SpinKitHourGlass(
      color: Colors.white,
      size: 50.0,
    ),
  );
}
