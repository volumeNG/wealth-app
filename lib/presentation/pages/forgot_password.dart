import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/features/authentication/requests/auth_request.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/input_field.dart';

import '../colors.dart';
import '../font_sizes.dart';

// final emailProvider = Provider<String>((_) => "Hwllo");

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String type = "";
  final emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/wealthLogo.png",
                  width: 150, // responsive width
                  height: 150, // responsive height
                ),
              ),
              SizedBox(
                height: 43.sp,
              ),
              Container(
                width: width,
                child: Text(
                  "Forgot Password",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 30.sp,
                    color: headerBrown,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Input your email address to reset password.",
                style: GoogleFonts.poppins(
                  color: Color(0xd01f160f).withOpacity(0.6),
                  fontSize: text__normal,
                ),
              ),
              SizedBox(
                height: 32.sp,
              ),
              InputField(
                  inputTitle: "",
                  hintText: "Enter your email address",
                  prefixIcon: Icons.email_outlined,
                  // prefixIcon: Icons.phone_outlined,
                  controller: emailController),
              SizedBox(
                height: 40,
              ),
              BTN(
                width: width,
                text: "Verify",
                onTap: () async {
                  var response = await sendForgotEmail(emailController.text);
                  if (response != null) {
                    if (response["success"] == false) {
                      showErrorDialog(context, response["message"]);
                    } else {
                      context
                          .push("/forgotVerification/" + emailController.text);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
