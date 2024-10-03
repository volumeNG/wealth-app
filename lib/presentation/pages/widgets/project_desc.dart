import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors.dart';
import '../../font_sizes.dart';

class ProjectDescText extends StatefulWidget {
  const ProjectDescText(
      {Key? key,
      required this.width,
      required this.location,
      required this.property,
      required this.fundRaised,
      required this.targetFund,
      this.rooms,
      this.initial = false,
      this.size,
      this.floor})
      : super(key: key);

  @override
  State<ProjectDescText> createState() => _ProjectDescTextState();

  final double width;
  final String location;
  final String property;
  final int fundRaised;
  final dynamic rooms;
  final dynamic size;
  final int targetFund;
  final dynamic floor;
  final bool initial;
}

class _ProjectDescTextState extends State<ProjectDescText> {
  late final formattedNumber;
  late final targetFormattedNumber;

  double calculateProgressPercentage() {
    if (widget.targetFund != 0 && widget.targetFund != null) {
      return (widget.fundRaised / widget.targetFund) * 100;
    } else {
      return 0.0; // To avoid division by zero
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedNumber = NumberFormat('#,###,###').format(widget.fundRaised);
    targetFormattedNumber = NumberFormat('#,###,###').format(widget.targetFund);
  }

  @override
  Widget build(BuildContext context) {
    double progressPercentage = calculateProgressPercentage();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: greenIcon,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.location,
                style: GoogleFonts.poppins(
                  color: Color(0xff4E4F50),
                  fontWeight: FontWeight.w400,
                  fontSize: text__md,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.property,
            style: GoogleFonts.poppins(
              color: secondaryColor,
              fontSize: section__normal,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.size != null
                  ? Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/metric.png"),
                          color: greenIcon,
                          size: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.size}m" ?? "",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xff4E4F50),
                                fontWeight: FontWeight.w500,
                                fontSize: text__sm,
                                letterSpacing: 1.sp,
                              ),
                            ),
                            Text(
                              "2",
                              style: GoogleFonts.poppins(
                                color: Color(0xff4E4F50),
                                fontSize: 6.sp,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(width: 10.sp,),
              // widget.rooms != null
              //     ? Row(
              //         children: [
              //           ImageIcon(
              //             AssetImage("assets/images/rooms.png"),
              //             color: greenIcon,
              //           ),
              //           Text(
              //             "${widget.rooms} rooms",
              //             style: GoogleFonts.poppins(
              //               color: Color(0xff4E4F50),
              //               fontWeight: FontWeight.w500,
              //               fontSize: text__sm,
              //               letterSpacing: 1.sp,
              //             ),
              //           )
              //         ],
              //       )
              //     : SizedBox.shrink(),
              widget.floor != null
                  ? Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/floors.png"),
                          color: greenIcon,
                        ),
                        Text(
                          "${widget.floor.toString()} Floor",
                          style: GoogleFonts.poppins(
                            color: Color(0xff4E4F50),
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fund Raised",
                    style: GoogleFonts.poppins(
                      color: Color(0xff6B6B6F),
                      fontSize: text__xs,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    formattedNumber.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4E4F50),
                      fontSize: text__sm,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Target Fund",
                    style: GoogleFonts.poppins(
                      color: Color(0xff6B6B6F),
                      fontSize: text__xs,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    targetFormattedNumber.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4E4F50),
                      fontSize: text__sm,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 3.sp,
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 8.sp,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              Container(
                width: widget.initial != false
                    ? (MediaQuery.of(context).size.width * 0.75) *
                        (progressPercentage / 100)
                    : MediaQuery.of(context).size.width *
                        (progressPercentage / 100),
                height: 8.sp,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
