import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wealth/features/authentication/requests/auth_request.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../font_sizes.dart';

class ForgotVerification extends ConsumerStatefulWidget {
  const ForgotVerification({Key? key, required this.emailAddress})
      : super(key: key);

  final String emailAddress;

  @override
  ConsumerState<ForgotVerification> createState() => _ForgotVerificationState();
}

final passwordChangeProvider = StateProvider<ChangePassword>(
    (ref) => ChangePassword(email: "email", token: 0, password: "password"));

class _ForgotVerificationState extends ConsumerState<ForgotVerification> {
  final verificationCodeController = TextEditingController();
  String currentText = "";

  @override
  void dispose() {
    verificationCodeController.dispose();
    super.dispose();
  }

  handleSubmit() async {
    if (currentText.length > 3) {
      var response =
          await verifyForgotToken(widget.emailAddress, int.parse(currentText));
      if (response != null) {
        if (response["success"] == false) {
          showErrorDialog(context, response["message"]);
        } else {
          ref.read(passwordChangeProvider.notifier).state.email =
              widget.emailAddress;
          ref.read(passwordChangeProvider.notifier).state.token =
              int.parse(verificationCodeController.text);
          context.push("/resetPassword");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Verification",style: GoogleFonts.poppins(
          fontSize: 30.sp,
        ),),
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Ink(
            child: Row(
              children: [
                Container(
                  width: 38.sp,
                  height: 38.sp,
                  padding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios_new, size: 15.sp),
                  ),
                  decoration: BoxDecoration(
                      color: appBarIcon,
                      border: Border.all(
                        color: Color(0xffDDC9BB),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.emailAddress,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: width * 0.09,
                color: Color(0xff0B0D0F),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please enter, Verification code",
              style: GoogleFonts.poppins(
                color: Color(0xd01f160f).withOpacity(0.6),
                fontSize: text__normal,
              ),
            ),
            SizedBox(
              height: 24.sp,
            ),
            Container(
              width: width * 0.7,
              child: PinCodeTextField(
                showCursor: true,
                appContext: context,
                hintCharacter: "*",
                autoDismissKeyboard: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                autoDisposeControllers: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,
                  // borderRadius: BorderRadius.circular(15),
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
                onCompleted: (v) async {
                  /**This is where the method would run after the code is fully inputted*/
                  print("Completed");
                  // context.go("/verificationOngoing");
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
            SizedBox(
              height: height * 0.06,
            ),
            Center(
              child: BTN(
                width: width,
                text: "Continue",
                onTap: handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePassword {
  String email;
  int token;
  String password;

  ChangePassword(
      {required this.email, required this.token, required this.password});
}
