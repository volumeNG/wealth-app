import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClipPathTest extends StatelessWidget {
  const ClipPathTest({Key? key, required this.widget}) : super(key: key);
final Widget widget;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomClipPath(),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.only(top: 40,left: 20,right: 20),
        child: Center(
          child: widget,
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
    throw UnimplementedError();
  }

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, 100);
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, 100);
    path.quadraticBezierTo(w * 0.5, 0, 0, 100);
    path.close();

    return path;
  }
}
