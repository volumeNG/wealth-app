import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';

import '../colors.dart';

class VerificationOngoing extends StatelessWidget {
  const VerificationOngoing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 270,
                  child: Stack(
                    children: [
                      Positioned(
                        left: width * 0.15,
                        top: 10,
                        child: Image.asset("assets/images/verification_bg.png",
                            fit: BoxFit.contain, repeat: ImageRepeat.noRepeat),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          "assets/images/verification_successful.png",
                          height: 300,
                          width: 300,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Your account created",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: softBlack,
                    fontSize: width * 0.06,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "You’re account has been created successfully."
                  " You will receive a call from our customer care once verified.",
                  textAlign: TextAlign.center,
                  style: secondaryText,
                ),
                SizedBox(
                  height: 40,
                ),
                BTN(
                  width: width,
                  text: "Sign In",
                  onTap: () => {
                    print("hello this is only the way i know"),
                    context.go("/signIn")
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
