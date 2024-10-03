import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealth/features/authentication/models/SignUp.dart';
import 'package:wealth/features/authentication/requests/auth_request.dart';
import 'package:wealth/features/profile/requests/requests.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:wealth/presentation/font_sizes.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/input_field.dart';
import 'package:wealth/state.dart';
import 'package:wealth/storage/secure_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'homepage.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isChecked = false;
  bool disabled = true;
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  late FocusNode emailNode;
  late FocusNode passwordNode;

  void _saveToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', emailAddressController.text);
  }

  void _loadFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myText = prefs.getString('userEmail');
    setState(() {
      emailAddressController.text = myText ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFromPreferences();
    emailNode = FocusNode();
    passwordNode = FocusNode();
  }

  @override
  void dispose() {
    emailAddressController.dispose();
    passwordController.text = "";
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    if (emailAddressController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      if (_key.currentState!.validate()) {
        context.loaderOverlay.show(
          widget: const Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: linkTextOrange,
                    backgroundColor: Colors.white,
                    strokeWidth: 5,
                  ),
                ],
              ),
            ),
          ),
        );
        var response = await signIn(
            emailAddressController.text.trim(), passwordController.text);
        context.loaderOverlay.hide();
        if (response != null) {
          if (response["statusCode"] != 500 && response["success"] == false) {
            showErrorDialog(context, response["message"]);
          } else if (response["success"]) {
            SecureStorage _storage = SecureStorage();
            UserSignUp userSignUp = await UserSignUp.fromJson(response["data"]);
            if (userSignUp.user?.isVerified == false) {
              showUserADialog(
                  context,
                  "Your account is not verified yet. Once you verified, you can sign in",
                  false,
                  () => null,
                  "");
            } else {
              if (isChecked) {
                _saveToPreferences();
              }
              await _storage.deleteSecureData("accessToken");
              await _storage.writeSecureData(
                  "accessToken", userSignUp.accessToken!);
              await updateDeviceToken(
                  OneSignal.User.pushSubscription.id.toString(),
                  userSignUp.user!.id!);
              ref.read(refreshHomePageProvider)(context);
              ref.read(userSignIn.notifier).state = userSignUp;
              context.go("/initial_page");
            }
          }
        }
      }
    } else {
      showErrorDialog(context, "Please input fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true, splitScreenMode: true);

    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        return onBackButtonPressed(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: 1.sh, // 100% of screen height
              padding: EdgeInsets.all(20.w), // responsive padding
              color: Colors.white,
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/wealthLogo.png",
                        width: 150, // responsive width
                        height: 150, // responsive height
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 1.sw, // 100% of screen width
                          child: Text(
                            "Sign In To Wealth",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30.sp, // responsive font size
                              color: Color(0xff282829),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h, // responsive height
                        ),
                        InputField(
                            controller: emailAddressController,
                            inputTitle: "Email address",
                            prefixIcon: Icons.email_outlined,
                            focusNode: emailNode,
                            hintText: "Enter email"),
                        SizedBox(
                          height: 20.h, // responsive height
                        ),
                        InputField(
                            controller: passwordController,
                            inputTitle: "Password",
                            focusNode: passwordNode,
                            prefixIcon: Icons.lock_outline_rounded,
                            password: true,
                            hintText: "*********"),
                        SizedBox(
                          height: 10.h, // responsive height
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                    activeColor: orangeTextColor,
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked = !isChecked;
                                      });
                                    }),
                                Text(
                                  "Remember Me",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight
                                          .w400), // responsive font size
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                context.push("/forgotPassword");
                              },
                              child: Text(
                                "Forgot Password",
                                style: GoogleFonts.poppins(
                                  color: textAccentColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: text__sm, // responsive font size
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.h, // responsive height
                        ),
                        BTN(
                          width: 1.sw, // 100% of screen width
                          text: "Sign in",
                          onTap: handleSubmit,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push("/signUp");
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                              color: textAccentColor, fontSize: text__md),
                          // responsive font size
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                  color: orangeTextColor,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: text__md), // responsive font size
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future showUserADialog(BuildContext context, String text, bool action,
    Function() onTap, String? buttonText) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.r), // responsive radius
        ),
      ),
      title: null,
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: text,
          style: GoogleFonts.poppins(
            color: Color(0xff828282),
            fontSize: 14.sp, // responsive font size
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      actions: action
          ? [
              BTN(
                width: 0.9.sw, // 90% of screen width
                onTap: onTap,
                text: buttonText!,
              )
            ]
          : [],
    ),
  );
}
