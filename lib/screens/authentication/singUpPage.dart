import 'package:emo_etry_app/authServices/auth.dart';
import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/helperFunctions/helperFunction.dart';
import 'package:emo_etry_app/screens/functionality/homeScreen.dart';
import 'package:emo_etry_app/widgets/customLoadingScreen.dart';
import 'package:emo_etry_app/widgets/welcomeHeading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;
  const RegisterScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
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
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/Subtract.png"),
                    ),
                  ),
                ),
                WelcomeHeading(
                  topLevel: MediaQuery.of(context).size.height / 7.5,
                  leftLevel: MediaQuery.of(context).size.width / 4.3,
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 3.2,
                  left: MediaQuery.of(context).size.width / 2.8,
                  child: Column(
                    children: [
                      Text("Sign Up",
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
                    top: MediaQuery.of(context).size.height / 2.6,
                    left: 30,
                    right: 30,
                  ),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? 'Please enter your name' : null,
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                labelText: 'Name',
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
                            validator: (val) =>
                                val!.isEmpty ? 'Please enter an email' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val.toString().trim();
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
                            validator: (val) => val!.length < 6
                                ? 'Password must be atleast 6 characters'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            style: const TextStyle(color: Colors.white),
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
                              print("Sign up tapped!");
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                print(name);
                                print(email);
                                print(password);
                                dynamic result =
                                    await auth.registerUserWithEmailAndPassword(
                                        name, email, password);
                                if (result != null) {
                                  print("Result: " + result.toString());
                                  await HelperFunction
                                      .saveUserIDSharedPreference(
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
                                  print("User login Unsuccessfull!!");
                                  setState(() {
                                    isLoading = false;
                                    error =
                                        "Credentials provided is incorrect!!!";
                                  });
                                }
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
                                'Sign Up',
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
                              print("google Sign In tapped!!");
                              setState(() {
                                isLoading = true;
                              });
                              dynamic result =
                                  await auth.registerUserWithGoogleAccount();
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
                                    "  Sign up using Google",
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
                                "Already have an account?",
                                style: GoogleFonts.poppins(
                                    textStyle:
                                        TextStyle(color: Color(0xFF818FA3))),
                              ),
                              TextButton(
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  child: Text(" Sign In",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                      ))))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      )),
                )
              ],
            ),
          );
  }
}
