import 'package:emo_etry_app/databaseServices/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Registering with user Email and Password
  Future registerUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await DatabaseServices(uid: user.user!.uid).addUsersToFirebase(
          name,
          email,
          '',
          "https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg");
      return user.user!.uid;
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //Loging in with user Email and Password
  Future signInUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return user.user!.uid;
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //SignOut
  Future SignOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Exception is: " + e.toString());
    }
  }

  //Registering user with Google Account for first time
  Future registerUserWithGoogleAccount() async {
    try {
      //Dialog box opens showing all google Accounts
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //Obtains Auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      //Create a new Credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //Finally Signing in using firebase
      UserCredential user = await _auth.signInWithCredential(credential);
      await DatabaseServices(uid: user.user!.uid).addUsersToFirebase(
          user.user!.displayName.toString(),
          user.user!.email.toString(),
          '',
          user.user!.photoURL.toString());
      return user.user!.uid;
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }

  //Sigining up user with google account
  Future signInUserWithGoogleAccount() async {
    try {
      //Dialog box opens showing all google Accounts
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //Obtains Auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      //Create a new Credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //Finally Signing in using firebase
      UserCredential user = await _auth.signInWithCredential(credential);
      return user.user!.uid;
    } catch (e) {
      print("Exception is: " + e.toString());
      return null;
    }
  }
}
