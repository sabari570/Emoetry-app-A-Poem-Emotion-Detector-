import 'package:emo_etry_app/authServices/auth.dart';
import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/helperFunctions/helperFunction.dart';
import 'package:emo_etry_app/screens/functionality/homeScreen.dart';
import 'package:emo_etry_app/widgets/customLoadingScreen.dart';
import 'package:emo_etry_app/widgets/welcomeHeading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  const LoginScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;
  AuthServices auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  color: const Color(0xFF000113),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/Subtract.png"),
                    ),
                  ),
                ),
                WelcomeHeading(
                  topLevel: MediaQuery.of(context).size.height / 6,
                  leftLevel: MediaQuery.of(context).size.width / 4.3,
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.3,
                  left: MediaQuery.of(context).size.width / 2.6,
                  child: Column(
                    children: [
                      Text("Sign In",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2,
                    left: 30,
                    right: 30,
                  ),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          TextFormField(
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please enter an email'
                                  : null;
                            },
                            onChanged: (value) {
                              return setState(() {
                                email = value.toString().trim();
                              });
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  color: Colors.white,
                                )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                ))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (value) {
                              return value!.length < 6
                                  ? 'Password must be atleast 6 characters'
                                  : null;
                            },
                            onChanged: (value) => setState(() {
                              password = value.toString().trim();
                            }),
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  color: Colors.white,
                                )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                ))),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              print("Sign in tapped!");
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                              }
                              print(email);
                              print(password);
                              dynamic result =
                                  await auth.signInUserWithEmailAndPassword(
                                      email, password);
                              if (result != null) {
                                print("Result: " + result.toString());
                                await HelperFunction.saveUserIDSharedPreference(
                                    result.toString());
                                Constants.userID = result.toString();
                                await HelperFunction
                                    .saveUserLoggedInSharedPreference(true);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const HomePage(
                                    imagePath: "",
                                  );
                                }));
                              } else {
                                print("User Login Unsuccessfull!!");
                                setState(() {
                                  isLoading = false;
                                  error =
                                      "Credentials provided is incorrect!!!";
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFF334155)),
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Or continue with",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF818FA3),
                              )),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              print("Google Sign in tapped!!");
                              setState(() {
                                isLoading = true;
                              });
                              dynamic result =
                                  await auth.signInUserWithGoogleAccount();
                              if (result != null) {
                                print("Result: " + result.toString());

                                await HelperFunction.saveUserIDSharedPreference(
                                    result.toString());
                                Constants.userID = result.toString();
                                await HelperFunction
                                    .saveUserLoggedInSharedPreference(true);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const HomePage(
                                    imagePath: "",
                                  );
                                }));
                              } else {
                                print("User Login Unsuccessfull!!");
                                setState(() {
                                  isLoading = false;
                                  error =
                                      "Credentials provided is incorrect!!!";
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFF818FA3)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/search.png'),
                                  Text(
                                    "  Sign in using Google",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        TextStyle(color: Color(0xFF818FA3))),
                              ),
                              TextButton(
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  child: Text(" Create now",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                      ))))
                            ],
                          )
                        ],
                      )),
                )
              ],
            ),
          );
  }
}
