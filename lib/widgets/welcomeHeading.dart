import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeHeading extends StatelessWidget {
  final double topLevel;
  final double leftLevel;
  WelcomeHeading({required this.topLevel, required this.leftLevel});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: topLevel,
        left: leftLevel,
        child: Row(
          children: [
            Image.asset(
              "assets/Emoetry Logo.png",
              height: 80,
              width: 80,
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Text(
                  "EMO-ETRY",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
                ),
                Text(
                  "Feel the words",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
                ),
              ],
            )
          ],
        ));
  }
}
