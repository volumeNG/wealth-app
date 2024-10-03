import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wealth/presentation/pages/onboarding_components/test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage(
      {Key? key,
      required this.widget,
      required this.color,
      required this.assetPath})
      : super(key: key);
  final Widget widget;
  final Color color;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: color,
              ),
            ),
            Positioned(
                bottom: MediaQuery.of(context).size.height * 0.2, child: Image.asset("assets/images/$assetPath.png"),width: 360.sp),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipPathTest(
                  widget: widget,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//
// Container(
// height: 350,
// width: MediaQuery.of(context).size.width,
// alignment: Alignment.bottomCenter,
// decoration: BoxDecoration(
// color: Colors.orange,
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(180),
// topRight: Radius.circular(180))),
// child: Stack(
// children: [
// Container(
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(400),
// topRight: Radius.circular(400)),
// ),
// height: 180,
// width: MediaQuery.of(context).size.width,
// ),
// Column(
// children: [
// Text("This is soemthing"),
// ],
// ),
// ],
// ),
// ),
