import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedPoemsDisplayScreen extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const SavedPoemsDisplayScreen({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Saved Poems Page: ${documentSnapshot.data()}");
    return Scaffold(
      backgroundColor: const Color(0xFF000113),
      appBar: AppBar(
        title: Text(
          "${documentSnapshot.get("stanzas")[0]}",
          maxLines: 1,
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
                  itemCount: documentSnapshot.get("emotions").length,
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
                            documentSnapshot.get("stanzas")[index],
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
                              documentSnapshot.get("emotions")[index],
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
    );
    ;
  }
}
