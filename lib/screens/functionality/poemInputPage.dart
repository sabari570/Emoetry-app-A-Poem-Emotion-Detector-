import 'package:cached_network_image/cached_network_image.dart';
import 'package:emo_etry_app/authServices/auth.dart';
import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/databaseServices/database.dart';
import 'package:emo_etry_app/helperFunctions/helperFunction.dart';
import 'package:emo_etry_app/screens/authentication/authenticate.dart';
import 'package:emo_etry_app/screens/functionality/predictedResultScreen.dart';
import 'package:emo_etry_app/widgets/customLoadingScreen.dart';
import 'package:emo_etry_app/widgets/pickImageWidget.dart';
import 'package:emo_etry_app/widgets/poemToStanza.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PoemInputPage extends StatefulWidget {
  final String imagePath;
  const PoemInputPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<PoemInputPage> createState() => _PoemInputPageState();
}

class _PoemInputPageState extends State<PoemInputPage> {
  AuthServices auth = AuthServices();
  DatabaseServices databaseServices = DatabaseServices(uid: Constants.userID);
  dynamic userInfo;
  int selectedIndex = 1;
  String imageUrl = "";
  String errorText = '';
  TextEditingController inputPoemController = TextEditingController();
  bool isLoading = false;
  bool isPredictingEmotion = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfoFromFirebase();
    processingTextFromImage();
  }

  @override
  void dispose() {
    inputPoemController.dispose();
    super.dispose();
  }

  getUserInfoFromFirebase() async {
    userInfo = await databaseServices.fetchingUserInfo();
    print("UserInfo at home: " + userInfo.toString());
    print("UserName: " + userInfo['userName']);
    //print("Profile URL: " + userInfo['imageUrl']);
    setState(() {
      Constants.userName = userInfo['userName'];
      print("Constants username: " + Constants.userName);
      imageUrl = userInfo['imageUrl'];
      print("ImageUrl:" + imageUrl);
    });
  }

  processingTextFromImage() async {
    final InputImage inputImage = InputImage.fromFilePath(widget.imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    setState(() {
      isLoading = true;
    });

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    setState(() {
      isLoading = false;
      inputPoemController.text = recognizedText.text;
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> resultMap = {};
    return Scaffold(
      backgroundColor: const Color(0xFF000113),
      body: isPredictingEmotion
          ? const LoadingScreen()
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                            ),
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  imageUrl,
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                    image: const DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                          "assets/defaultProfile.jpg",
                                        ))),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text("Hello " + Constants.userName,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ))),
                      Text("Welcome Back!",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ))),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: inputPoemController,
                        maxLines: null,
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                        decoration: InputDecoration(
                            hintText: "Input your poem...",
                            hintStyle: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                              color: Color(0xFF848484),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                            filled: true,
                            fillColor: const Color(0xFF2B2B36),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Color(0xFF2B2B36))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Color(0xFF2B2B36))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 50, 50, 68),
                                    width: 4))),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          errorText,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            color: Colors.red,
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 3),
                        child: GestureDetector(
                          onTap: () async {
                            print("Predict Button clicked!!");
                            if (inputPoemController.text == '') {
                              setState(() {
                                errorText = 'Input a poem!!';
                              });
                            } else {
                              setState(() {
                                errorText = '';
                                isPredictingEmotion = true;
                              });
                              resultMap = await convertPoemToStanza(
                                  inputPoemController.text);
                              print("PoemInputScreen resultMap: $resultMap");
                              setState(() {
                                isPredictingEmotion = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PredictedResultScreen(
                                  resultMap: resultMap,
                                );
                              }));
                            }
                          },
                          child: Container(
                            height: 41,
                            width: 167,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFF334155)),
                            alignment: Alignment.center,
                            child: Text(
                              'Predict',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF1CF0D8),
          onPressed: () {
            modalSheet(context);
          },
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.black,
          )),
    );
  }
}
