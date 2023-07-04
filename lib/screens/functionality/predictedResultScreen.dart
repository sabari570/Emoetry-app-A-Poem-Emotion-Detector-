import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/databaseServices/database.dart';
import 'package:emo_etry_app/screens/functionality/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:core';

class PredictedResultScreen extends StatefulWidget {
  final Map<String, dynamic> resultMap;
  const PredictedResultScreen({Key? key, required this.resultMap})
      : super(key: key);

  @override
  State<PredictedResultScreen> createState() => _PredictedResultScreenState();
}

class _PredictedResultScreenState extends State<PredictedResultScreen> {
  List<List<String>> stanzas = [];
  List<String> emotions = [];
  DatabaseServices databaseServices = DatabaseServices(uid: Constants.userID);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.resultMap['stanzas'] != null &&
        widget.resultMap['emotions'] != null) {
      stanzas = widget.resultMap['stanzas'];
      emotions = widget.resultMap['emotions'];
    } else {
      stanzas = [];
      emotions = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000113),
      appBar: AppBar(
        title: Text(
          "Prediction Page",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: stanzas.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.topLeft,
                          decoration: const BoxDecoration(
                            color: Color(0xFF313242),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            stanzas[index].join("\n"),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(color: Colors.white),
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            width: 100,
                            alignment: Alignment.center,
                            child: Text(
                              emotions[index],
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1CF0D8),
        onPressed: () {
          print("Uid: ${Constants.userID}");
          String stanzaJoined;
          List<String> stanzaList = [];
          for (var stanza in widget.resultMap['stanzas']) {
            stanzaJoined = stanza.join("\n");
            stanzaList.add(stanzaJoined);
            print('----');
          }
          print("Stanza list $stanzaList");
          DateTime currentTime = DateTime.now();
          Map<String, dynamic> uploadData = {
            'stanzas': stanzaList,
            'emotions': widget.resultMap['emotions'],
            'createdAt': currentTime
          };
          dynamic result =
              databaseServices.savePoemAndEmotionsToFirebase(uploadData);
          if (result == null) {
            print("Upload Unsuccessfull!!");
          } else {
            print("Upload Successfull!!");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Uploaded Successfully',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(color: Colors.white)),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const HomePage(imagePath: '');
            }), (route) => false);
          }
        },
        child: const Icon(
          Icons.save,
          color: Colors.black,
        ),
      ),
    );
  }
}
