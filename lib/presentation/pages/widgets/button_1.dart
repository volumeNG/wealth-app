import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BTN extends StatelessWidget {
  const BTN(
      {super.key,
      required this.width,
      required this.onTap,
      required this.text,
      this.full = false,
      this.disabled = false});

  final String text;
  final double width;
  final VoidCallback? onTap;
  final bool full;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: full == false ? width * 0.8 : double.infinity,
        padding: EdgeInsets.symmetric(
          vertical:12.sp,
          horizontal: width * 0.20,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        decoration: BoxDecoration(
            color: disabled ? secondaryColor.withOpacity(0.7) : secondaryColor,
            borderRadius: BorderRadius.circular(1000)),
      ),
    );
  }
}
