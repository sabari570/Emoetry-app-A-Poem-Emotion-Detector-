// ignore: file_names
import 'dart:io';
import 'package:emo_etry_app/authServices/auth.dart';
import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/databaseServices/database.dart';
import 'package:emo_etry_app/helperFunctions/helperFunction.dart';
import 'package:emo_etry_app/screens/authentication/authenticate.dart';
import 'package:emo_etry_app/widgets/customLoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  AuthServices auth = AuthServices();
  DatabaseServices databaseServices = DatabaseServices(uid: Constants.userID);
  File? imageFile;
  dynamic userInfo;
  String imageUrl = '';
  String userEmail = '';
  String gender = '';
  bool isImageUploading = false;
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userEmailTextEditingController =
      TextEditingController();
  TextEditingController userGenderTextEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfoFromFirebase();
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
      userEmail = userInfo['userEmail'];
      print("Username: $userEmail");
      gender = userInfo['gender'];
      print("Gender: $gender");

      userNameTextEditingController.text = Constants.userName;
      userEmailTextEditingController.text = userEmail;
      userGenderTextEditingController.text = gender;
    });
  }

  pickImageOfUser() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage!.path != null) {
      print("PickedFile: ${pickedImage.path}");
      imageFile = File(pickedImage.path);
      print("ImageFile: $imageFile");
      setState(() {
        isImageUploading = true;
      });
      dynamic uploadedImageUrl = await databaseServices.uploadUserProfilePic(
          pickedImage.path, userEmail);
      print("UploadedImage url: $uploadedImageUrl");
      setState(() {
        isImageUploading = false;
        imageUrl = uploadedImageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000113),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 23, 141, 127),
                          shape: BoxShape.circle),
                    ),
                    isImageUploading
                        ? imageLoadingAnimation()
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 65,
                              backgroundImage: NetworkImage(
                                imageUrl,
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              height: 150,
                              width: 150,
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
              Positioned(
                  bottom: 0,
                  right: MediaQuery.of(context).size.width / 3.1,
                  child: GestureDetector(
                    onTap: () {
                      pickImageOfUser();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Color.fromARGB(255, 23, 141, 127),
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 90,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 50),
                  child: Column(children: [
                    TextField(
                      controller: userNameTextEditingController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0XFF313242),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0XFF1CF0D8),
                        ),
                        labelText: 'Username',
                        labelStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Color(0XFF1CF0D8),
                        )),
                        hintText: 'Username',
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Color.fromARGB(255, 99, 99, 99),
                        )),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 99, 102, 145),
                            width: 3,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: userEmailTextEditingController,
                      enabled: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0XFF313242),
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Color(0XFF1CF0D8),
                        ),
                        labelText: 'Email',
                        labelStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Color(0XFF1CF0D8),
                        )),
                        hintText: 'Email',
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Color.fromARGB(255, 99, 99, 99),
                        )),
                        border: InputBorder.none,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: userGenderTextEditingController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0XFF313242),
                        prefixIcon: (gender.toLowerCase() == 'male')
                            ? const Icon(
                                Icons.male,
                                color: Color(0XFF1CF0D8),
                              )
                            : (gender.toLowerCase() == 'female')
                                ? const Icon(
                                    Icons.female,
                                    color: Color(0XFF1CF0D8),
                                  )
                                : const Icon(
                                    Icons.male,
                                    color: Colors.transparent,
                                  ),
                        labelText: 'Gender',
                        labelStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Color(0XFF1CF0D8),
                        )),
                        hintText: 'Gender',
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Color.fromARGB(255, 99, 99, 99),
                        )),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 99, 102, 145),
                            width: 3,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await auth.SignOut();

                            print("Signed Out Successfully!!");
                            await HelperFunction
                                .saveUserLoggedInSharedPreference(false);
                            await HelperFunction.saveUserIDSharedPreference("");
                            Constants.userID = "";
                            Constants.userName = "";
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const Authenticate();
                            }));
                          },
                          child: Container(
                            height: 50,
                            width: 125,
                            decoration: BoxDecoration(
                                color: const Color(0XFF313242),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Color(0XFF1CF0D8),
                                ),
                                Text(
                                  "  Logout",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                    fontSize: 16,
                                  )),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print("Update button clicked!!");
                            dynamic result =
                                await databaseServices.updateUserProfileInfo(
                                    userNameTextEditingController.text,
                                    userEmail,
                                    userGenderTextEditingController.text,
                                    imageUrl);

                            if (result) {
                              print("Updated Successfully!!");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Updated Successfully',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              setState(() {
                                getUserInfoFromFirebase();
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 125,
                            decoration: BoxDecoration(
                                color: const Color(0XFF313242),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.edit,
                                  color: Color(0XFF1CF0D8),
                                ),
                                Text(
                                  "  Update",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
