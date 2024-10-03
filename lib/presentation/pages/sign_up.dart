import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wealth/features/authentication/models/SignUp.dart';
import 'package:wealth/features/authentication/requests/auth_request.dart';
import 'package:wealth/presentation/pages/sign_in.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/input_field.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../storage/secure_storage.dart';
import '../colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../font_sizes.dart';
import 'homepage.dart';

final signUpResponseProvider = StateProvider<UserSignUp?>((ref) => null);

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String phoneNumber = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    emailAddressController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _signUp() async {
      if (_formKey.currentState!.validate()) {
        if (nameController.text.isNotEmpty &&
            phoneNumberController.text.isNotEmpty &&
            emailAddressController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          final bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(emailAddressController.text);
          if (emailValid) {
            if (isChecked) {
              if (passwordController.text.length < 8) {
                showErrorDialog(
                    context, "Password Length cannot be less than 8");
              } else {
                context.loaderOverlay.show(
                  widget: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: linkTextOrange,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          strokeWidth: 5,
                        ),
                      ],
                    ),
                  ),
                );
                dynamic response = await signUp(
                    name: nameController.text.trim(),
                    email: emailAddressController.text.trim(),
                    password: passwordController.text,
                    phoneNumber: phoneNumberController.text.trim());
                context.loaderOverlay.hide();
                if (response != null) {
                  if (response["success"] == false) {
                    showErrorDialog(context, response["message"]);
                  } else {
                    SecureStorage storage = SecureStorage();
                    UserSignUp userSignUp =
                        UserSignUp.fromJson(response["data"]);
                    await storage.deleteSecureData("accessToken");
                    await storage.writeSecureData(
                        "accessToken", userSignUp.accessToken!);
                    ref.read(signUpResponseProvider.notifier).state =
                        userSignUp;
                    ref.invalidate(signUpResponseProvider);
                    context.push("/verify");
                  }
                } else {}

                // if (response != null) {
                //   SecureStorage storage = SecureStorage();
                //   storage.writeSecureData("accessToken", response.accessToken!);
                //   ref.read(signUpResponseProvider.notifier).state = response;
                //   context.push("/verify");
                // } else {
                //   showErrorDialog(context, "User account unable to be created");
                // }
              }
            } else {}
          } else {
            showErrorDialog(context, "Invalid Email Address");
          }
        } else {
          showErrorDialog(context, "Please Input All Fields");
        }
      }
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        return onBackButtonPressed(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: height - 45.sp,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/wealthLogo.png"),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: width,
                          child: Text(
                            "Sign Up For Free",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30.sp, // responsive font size
                              color: Color(0xff282829),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        InputField(
                            controller: nameController,
                            inputTitle: "Full Name",
                            prefixIcon: Icons.person_2_outlined,
                            hintText: "Enter Full Name"),
                        SizedBox(
                          height: 16.sp,
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text("Phone Number"),
                        //     SizedBox(height: 15),
                        //     IntlPhoneField(
                        //       cursorColor: Colors.black54,
                        //       decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.all(15),
                        //         border: OutlineInputBorder(
                        //           borderSide:
                        //               BorderSide(width: 1.0, color: Colors.grey),
                        //           borderRadius: BorderRadius.circular(14),
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //               width: 1.0, color: serenityGreen),
                        //           borderRadius: BorderRadius.circular(14),
                        //         ),
                        //         counterText: '',
                        //       ),
                        //       initialCountryCode: 'NG',
                        //       onChanged: (phone) {
                        //         // print(phone.completeNumber.indexOf("0"));
                        //         print(phone.completeNumber.substring(4));
                        //         setState(() {
                        //           phoneNumber = phone.completeNumber;
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        InputField(
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            inputTitle: "Enter Phone Number",
                            prefixIcon: Icons.phone_outlined,
                            hintText: "Enter Phone Number"),
                        SizedBox(
                          height: 16.sp,

                        ),
                        InputField(
                            controller: emailAddressController,
                            inputTitle: "Email Address",
                            prefixIcon: Icons.email_outlined,
                            hintText: ".......@mail.com"),
                        SizedBox(
                          height: 16.sp,
                        ),
                        InputField(
                            controller: passwordController,
                            inputTitle: "Password",
                            password: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            hintText: "Password"),
                        SizedBox(
                          height: 12.sp,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: isChecked,
                                activeColor: linkTextOrange,
                                focusColor: linkTextOrange,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                }),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsAndCondition(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "I Agree With the ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: text__sm,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: linkTextOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        BTN(
                          width: width,
                          text: "Sign Up",
                          onTap: () async {
                            // Auth _auth = new Auth();
                            await _signUp();
                          },
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push("/signIn");
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: textAccentColor),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                      color: orangeTextColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600),
                                  // Add onTap handler if you want to make it clickable
                                  // recognizer: TapGestureRecognizer()..onTap = () {
                                  //   // Your onTap logic here
                                  // },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Terms and conditions'),
        ),
        body: WebView(
          initialUrl: "https://wealth-tndc.onrender.com/",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

void showErrorDialog(BuildContext context, String errorMessage) {
  InAppNotification.show(
    child: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            errorMessage,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.red.withOpacity(0.99),
        ),
      ),
    ),
    context: context,
    duration: Duration(seconds: 2),
    onTap: () => print('Notification tapped!'),
  );
}
