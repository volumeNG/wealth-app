import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors.dart';

class CurrentDescText extends StatefulWidget {
  const CurrentDescText(
      {Key? key,
      required this.width,
      required this.location,
      required this.property,
      required this.price,
      this.rooms,
      this.size,
      this.floor})
      : super(key: key);

  @override
  State<CurrentDescText> createState() => _CurrentDescTextState();

  final double width;
  final String location;
  final String property;
  final int price;
  final dynamic rooms;
  final dynamic size;
  final dynamic floor;
}

class _CurrentDescTextState extends State<CurrentDescText> {
  late final formattedNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedNumber = NumberFormat('#,###,###').format(widget.price);
  }

  @override
  Widget build(BuildContext context) {
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
                  fontSize: widget.width * 0.04,
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
              fontSize: widget.width * 0.055,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.size != null
                  ? Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/metric.png"),
                          color: greenIcon,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.size}m" ?? "",
                              style: GoogleFonts.poppins(
                                color: Color(0xff4E4F50),
                              ),
                            ),
                            Text(
                              "2",
                              style: GoogleFonts.poppins(
                                color: Color(0xff4E4F50),
                                fontSize: 8.sp,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage("assets/images/tag.png"),
                color: greenIcon,
              ),
              SizedBox(
                width: 5,
              ),
              ImageIcon(
                AssetImage("assets/images/naira_grey.png"),
              ),
              Text(
                formattedNumber.toString(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Color(0xff222222),
                  fontSize: 16.sp,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
