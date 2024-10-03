import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wealth/features/current_locations/requests/current_locations_requests.dart';
import 'package:wealth/features/flipping/requests/flipping_requests.dart';

import '../../../utilities.dart';
import '../../colors.dart';
import '../../font_sizes.dart';
import '../sign_up.dart';

class propertyListing extends StatefulWidget {
  const propertyListing(
      {super.key,
      required this.width,
      required this.propertyName,
      required this.location,
      required this.propertySize,
      required this.roomNumber,
      this.propertyType = "House",
      this.onTap,
      this.onBookmark,
      this.id,
      this.favourite = false,
      this.thumbnail = "",
      this.saveType,
      this.status,
      this.propertyPrice});

  final double width;
  final String? id;
  final String? status;
  final String propertyName;
  final String location;
  final String propertySize;
  final dynamic roomNumber;
  final String? propertyType;
  final Function()? onTap;
  final Function(String)? onBookmark;
  final int? propertyPrice;
  final String thumbnail;
  final bool? favourite;
  final String? saveType;

  @override
  State<propertyListing> createState() => _propertyListingState();
}

class _propertyListingState extends State<propertyListing> {
  bool bookmark = false;
  late final formattedNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.propertyPrice != null) {
      formattedNumber = NumberFormat('#,###,###').format(widget.propertyPrice);
    } else {
      formattedNumber = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onTap,
          child: Ink(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: widget.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  image: widget.thumbnail.isEmpty
                                      ? AssetImage("assets/images/house.png")
                                      : NetworkImage(widget.thumbnail)
                                          as ImageProvider,
                                  fit: BoxFit.cover)),
                        ),
                        widget.favourite == true
                            ? SizedBox.shrink()
                            : Positioned(
                                right: 20,
                                top: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.88),
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  child: IconButton(
                                    onPressed: () async {
                                      var response;
                                      if (widget.saveType != null) {
                                        if (widget.saveType == "flipping") {
                                          response =
                                              await saveFlipping(widget.id!);
                                        } else if (widget.saveType ==
                                            "current") {
                                          response =
                                              await saveCurrentLocationProperty(
                                                  widget.id!);
                                        } else {
                                          response = null;
                                        }
                                      }
                                      if (response["success"]) {
                                        setState(() {
                                          bookmark = true;
                                        });
                                      } else if (response["message"] ==
                                          "Already Saved") {
                                        setState(() {
                                          bookmark = true;
                                        });
                                      } else {
                                        showErrorDialog(
                                            context, "Unable to save");
                                      }
                                    },
                                    icon: Icon(Icons.bookmark,
                                        size: 20,
                                        color: bookmark
                                            ? Color(0xffD06F0E)
                                            : Colors.grey),
                                    padding: EdgeInsets.all(0),
                                  ),
                                ),
                              ),
                        Positioned(
                          left: 20,
                          top: 20,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.sp, horizontal: 12.sp),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              formatDropdownString(widget.propertyType!),
                              style: GoogleFonts.plusJakartaSans(
                                  color: Color(0xff282829),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
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
                      fontSize: text__sm,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              widget.status != null
                  ? Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xffDADEED),
                          ),
                          child: Text(
                            widget.status!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: Color(0xff4E4F50),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              Text(
                widget.propertyName,
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
                children: [
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("assets/images/metric.png"),
                        color: greenIcon,
                      ),
                      SizedBox(
                        width: 4.sp,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.propertySize != null
                                ? "${widget.propertySize} m"
                                : "",
                            style: GoogleFonts.poppins(
                              color: Color(0xff4E4F50),
                              fontSize: text__sm,
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
                  ),

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
                    width: 9.sp,
                  ),
                  ImageIcon(
                    AssetImage("assets/images/naira_grey.png"),
                  ),
                  formattedNumber != null
                      ? Text(
                          formattedNumber.toString(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff222222),
                            fontSize: text__normal,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
