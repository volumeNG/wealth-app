import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/features/authentication/requests/auth_request.dart';
import 'package:wealth/presentation/pages/forgot_verification.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/input_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  GlobalKey _key = GlobalKey<FormState>();

  submitPasswordChange() async {
    if (newPassword.text == confirmPassword.text) {
      ref.read(passwordChangeProvider.notifier).state.password =
          newPassword.text;
      var response = await changePassword(
          ref.watch(passwordChangeProvider.notifier).state.email,
          ref.watch(passwordChangeProvider.notifier).state.password,
          ref.watch(passwordChangeProvider.notifier).state.token);
      print(response);
      if (response != null) {
        if (response["success"] == false) {
          showErrorDialog(context, response["message"]);
        } else {
          context.push("/signIn");
        }
      }
    } else {
      showErrorDialog(context, "Password not the same");
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
        surfaceTintColor: Colors.transparent,
        title: Text("Verification"),
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
              "Reset Password",
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
              "Please enter your new password",
              style: GoogleFonts.poppins(
                color: Color(0xd01f160f),
                fontSize: width * 0.038,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  InputField(
                      controller: newPassword,
                      inputTitle: "",
                      prefixIcon: Icons.lock_outline_rounded,
                      password: true,
                      hintText: "Password"),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                      controller: confirmPassword,
                      inputTitle: "",
                      prefixIcon: Icons.lock_outline_rounded,
                      password: true,
                      hintText: "Confirm Password"),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Center(
              child: BTN(
                width: width,
                text: "Continue",
                onTap: () {
                  // print("hello this is only the way i know"),
                  // context.go("/signIn")
                  submitPasswordChange();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
