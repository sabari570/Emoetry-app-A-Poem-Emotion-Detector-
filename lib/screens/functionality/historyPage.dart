import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/databaseServices/database.dart';
import 'package:emo_etry_app/screens/functionality/savedPoemsDisplayScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DatabaseServices databaseServices = DatabaseServices(uid: Constants.userID);
  int selectedCardIndex = -1;
  showDeleteDialogBox(DocumentSnapshot documentSnapshot) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            title: Text(
              "Delete Poem",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                color: Color.fromARGB(255, 204, 204, 204),
              )),
            ),
            content: Text(
              "Are you sure you want to delete this Poem?",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                color: Colors.white,
              )),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedCardIndex = -1;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(color: Color(0xFF1CF0D8))),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Perform delete action here
                  setState(() {
                    selectedCardIndex = -1;
                  });
                  dynamic result =
                      databaseServices.deletePoemsSaved(documentSnapshot.id);
                  print("Result After Deletion: $result");
                  if (result != null) {
                    print("Poem Deleted Successfully!!");
                  } else {
                    print("Poem Deletion Unsuccessfully!!");
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    color: Colors.redAccent,
                  )),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000113),
      appBar: AppBar(
        title: Text(
          "History",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: StreamBuilder(
        stream: databaseServices.streamOfPoemSnapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return streamSnapshot.data!.docs.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      print("Document Snapshot: ${documentSnapshot.data()}");
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              selectedCardIndex = index;
                              showDeleteDialogBox(documentSnapshot);
                            });
                          },
                          onLongPressEnd: (_) {
                            setState(() {
                              selectedCardIndex = -1;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedCardIndex == index
                                  ? Colors.blue[100]
                                  : const Color(0xFF313242),
                              boxShadow: selectedCardIndex == index
                                  ? [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : [],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SavedPoemsDisplayScreen(
                                      documentSnapshot: documentSnapshot);
                                }));
                              },
                              child: Card(
                                elevation: 7,
                                shadowColor:
                                    const Color.fromARGB(255, 177, 182, 226),
                                color: selectedCardIndex == index
                                    ? const Color.fromARGB(255, 86, 92, 173)
                                    : const Color(0xFF313242),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    "${documentSnapshot.get("stanzas")[0]}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Text(
                      "Nothing yet",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                    ),
                  );
            ;
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
