import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealth/presentation/pages/onboarding.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _loadFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myText = prefs.getString('userEmail');
    if (myText != null ) {
      context.go("/signIn");
    } else {
      context.go("/initial_page");
    }
  }

  @override
  void initState() {
    super.initState(); // Call the super.initState() method first
    Future.delayed(const Duration(seconds: 5), () {
      // context.go("/onboarding");
      _loadFromPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/appLogo.png'),
            SizedBox(
              height: 30,
            ),
            Text(
              "BY PROMISELAND ESTATE",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                color: Color(0xff6B6B6F),
              ),
            )
          ],
        ),
      ),
    );
  }
}
