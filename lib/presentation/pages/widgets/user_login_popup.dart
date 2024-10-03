import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/components/chat/admin_chat.dart';

import '../../colors.dart';
import 'button_1.dart';

class UserLoginPopup extends StatelessWidget {
  const UserLoginPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: null,
      content: Container(
        // height: ,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.sp),
                width: 100.sp,
                height: 100.sp,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/LoginSpeaker.png"),
                  ),
                ),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              "The users must create account if they want to",
              style: GoogleFonts.poppins(
                color: Color(0xff6A6A6A),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage(
                            "assets/images/LoginList.png",
                          ),
                          color: Color(0xffD06F0E),
                        ),
                        SizedBox(
                          width: 8.sp,
                        ),
                        Text(
                          "Buy A House",
                          style: GoogleFonts.poppins(
                            color: Color(0xff24194D),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage(
                            "assets/images/LoginList.png",
                          ),
                          color: Color(0xffD06F0E),
                        ),
                        SizedBox(
                          width: 8.sp,
                        ),
                        Text(
                          "Chat in the group",
                          style: GoogleFonts.poppins(
                            color: Color(0xff24194D),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage(
                            "assets/images/LoginList.png",
                          ),
                          color: Color(0xffD06F0E),
                        ),
                        SizedBox(
                          width: 8.sp,
                        ),
                        Text(
                          "List a property",
                          style: GoogleFonts.poppins(
                            color: Color(0xff24194D),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                InkWell(
                  onTap: () {
                    context.go("/signUp");
                  },
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.sp,
                      // horizontal: width * 0.20,
                    ),
                    child: Center(
                      child: Text(
                        "Create Account",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(.9),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                InkWell(
                  onTap: () {
                    context.go("/signIn");
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
            )
          ],
        ),
      ),
    );
  }
}
