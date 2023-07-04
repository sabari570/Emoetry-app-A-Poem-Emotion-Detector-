import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseServices {
  final String uid;
  DatabaseServices({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  //Adding users to firebase
  Future addUsersToFirebase(
      String name, String email, String gender, String imageURL) async {
    try {
      return await users.doc(uid).set({
        'userName': name,
        'userEmail': email,
        'gender': gender,
        'imageUrl': imageURL
      });
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //Fetching the user Info
  Future fetchingUserInfo() async {
    try {
      DocumentSnapshot userSnapshot = await users.doc(uid).get();
      dynamic userInfo = userSnapshot.data();
      return userInfo;
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //Saving the poem and its predicted emotions to firebase
  savePoemAndEmotionsToFirebase(Map<String, dynamic> poemData) async {
    try {
      return await users.doc(uid).collection("poems").add(poemData);
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //Sending snapshots of poems of each logged in users
  streamOfPoemSnapshots() {
    try {
      return users
          .doc(uid)
          .collection("poems")
          .orderBy("createdAt", descending: true)
          .snapshots();
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //Deleting poems from firebase
  deletePoemsSaved(String docId) async {
    try {
      return await users.doc(uid).collection("poems").doc(docId).delete();
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //uploading user profile pic to firebase storage
  Future<String> uploadUserProfilePic(String imgPath, String userEmail) async {
    String uploadedImageUrl;
    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      //images Folder
      Reference referenceDirImages = referenceRoot.child('images');

      //File inside images folder
      Reference referenceImageToUpload = referenceDirImages.child(userEmail);

      //Storing the file in firebase storage
      await referenceImageToUpload.putFile(File(imgPath));

      //Getting the URL of the uploaded image
      uploadedImageUrl = await referenceImageToUpload.getDownloadURL();
      print(uploadedImageUrl);
      return uploadedImageUrl;
    } catch (e) {
      print("Exception is: " + e.toString());
      return '';
    }
  }

  //Updating the user profile
  Future<bool> updateUserProfileInfo(
      String name, String email, String gender, String imageURL) async {
    try {
      await users.doc(uid).set({
        'userName': name,
        'userEmail': email,
        'gender': gender,
        'imageUrl': imageURL
      });
      return true;
    } catch (e) {
      print("Exception is: " + e.toString());
      return false;
    }
  }
}
