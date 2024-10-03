import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wealth/features/authentication/models/SignUp.dart';
import 'package:wealth/features/authentication/requests/auth_request.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/sign_up.dart';

class VerifyEmailSignUp extends ConsumerStatefulWidget {
  const VerifyEmailSignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyEmailSignUp> createState() => _VerifyEmailSignUpState();
}

class _VerifyEmailSignUpState extends ConsumerState<VerifyEmailSignUp> {
  TextEditingController verificationCodeController = TextEditingController();
  String currentText = "";

  @override
  void dispose() {
    verificationCodeController.dispose();
    super.dispose();
  }

  // Auth _auth = new Auth();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Align(
                  child: Image.asset(
                    "assets/images/phone_verify.png",
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Verify your email",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: softBlack,
                        fontSize: width * 0.06,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "We need this to verify and secure your account. Enter 4 digit code to your email address.",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        color: secondaryTextColor,
                        // letterSpacing: 1.2,
                        fontSize: width * 0.04,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      ref
                              .watch(signUpResponseProvider.notifier)
                              .state
                              ?.user
                              ?.email ??
                          'No email available',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff181818),
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      child: PinCodeTextField(
                        showCursor: true,
                        appContext: context,
                        hintCharacter: "*",
                        autoDismissKeyboard: true,
                        autoDisposeControllers: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(15),
                          activeBorderWidth: 2,
                          selectedColor: greyColor2,
                          fieldWidth: 50,
                          activeFillColor: Colors.white,
                          activeColor: blackGrey,
                          inactiveFillColor: Colors.black54,
                          inactiveColor: Colors.black54,
                          selectedBorderWidth: 4,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: Duration(milliseconds: 300),
                        controller: verificationCodeController,
                        onCompleted: (value) async {
                          context.loaderOverlay.show(
                            widget: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: linkTextOrange,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    strokeWidth: 5,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Text(
                                  //   "Submitting Information",
                                  //   style: TextStyle(
                                  //       fontSize: 17,
                                  //       color: Colors.black12,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                ],
                              ),
                            ),
                          );
                          /**This is where the method would run after the code is fully inputted*/
                          print("Completed");
                          var response =
                              await verifyToken(token: int.parse(value));
                          // UserSignUp?
                          context.loaderOverlay.hide();
                          if (response != null) {
                            if (response["success"] == false) {
                              showErrorDialog(context, response["message"]);
                            } else {
                              context.pushReplacement("/verificationOngoing");
                            }
                          } else {
                            showErrorDialog(context, "OTP doesn't match");
                          }
                        },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        resendEmail(ref
                                .watch(signUpResponseProvider.notifier)
                                .state
                                ?.user
                                ?.email ??
                            '');
                      },
                      child: Text(
                        "Send it again",
                        style: TextStyle(
                          letterSpacing: 1.2,
                          color: orangeTextColor,
                          decoration: TextDecoration.underline,
                          decorationColor: orangeTextColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
