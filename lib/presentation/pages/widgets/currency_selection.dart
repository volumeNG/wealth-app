import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';

import '../../colors.dart';
import '../../font_sizes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Currency extends StatelessWidget {
  const Currency({
    super.key,
    required this.width,
    required this.usd,
    required this.asset,
    required this.type,
  });

  final double width;
  final bool usd;
  final String asset;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Container(
        width: width * 0.42,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
            color: usd ? Colors.orange : Colors.transparent,
            border: Border.all(
              width: 1,
              color: blackGrey,
            ),),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Image.asset(
              "assets/images/$asset.png",
              width: 60.sp,
              height: 60.sp,
            ),
            SizedBox(
              height: 10,
            ),
            type == "usd"
                ? Text(
                    "USD",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: usd ? Colors.white : secondaryColor,
                      fontSize: text__md,
                    ),
                  )
                : Text(
                    "Naira",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: usd ? Colors.white : secondaryColor,
                      fontSize: text__md,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
