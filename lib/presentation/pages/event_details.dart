import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:wealth/features/promotions/models/PromotionModel.dart';
import 'package:wealth/features/promotions/requests/promotion_requests.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import '../colors.dart';

class EventDetails extends ConsumerStatefulWidget {
  const EventDetails({Key? key, required this.id, required this.promotionModel})
      : super(key: key);

  final String id;
  final PromotionModel promotionModel;

  @override
  ConsumerState<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends ConsumerState<EventDetails> {
  int _currentPage = 1;
  bool interest = false;
  bool bookmark = false;
  int interestedLength = 0;

  checkIfUserIsAlreadyInterested() {
    List<Interesteds>? interested = widget.promotionModel.interesteds;
    if (interested != null && interested.isNotEmpty) {
      for (int i = 0; i < widget.promotionModel.interesteds!.length; i++) {
        if (widget.promotionModel.interesteds?[i].ownBy!.id! ==
            ref.read(profile_Provider.notifier).state.id) {
          setState(() {
            interest = true;
          });
          return;
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfUserIsAlreadyInterested();
  }

  @override
  Widget build(BuildContext context) {
    final refreshInterestedList = Provider((ref) {
      return (BuildContext context) async {
        await ref
            .refresh(fetchSinglePromotion(widget.promotionModel.id!).future);
        // await ref.refresh(getAllPromotions(_currentPage).future);
        await ref.refresh(getAllPromotions.future);
      };
    });




    AsyncValue<PromotionModel> promotion =
        ref.watch(fetchSinglePromotion(widget.promotionModel.id!));

    PromotionModel singlePromotionModel = PromotionModel();
    promotion.when(
        data: (data) {
          if (data != null) {
            singlePromotionModel = data;
            interestedLength = data.interesteds!.length ?? 0;
          }
        },
        error: (error, _) {},
        loading: () {});

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    // var inputDate = inputFormat.parse(widget.promotionModel.date!);
    DateTime tempDate = new DateTime.now();

    String? dateString =
        widget.promotionModel.date; // Make sure this is not null

    if (dateString != null) {
      tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(dateString);
    }

    showInterest(String Id) async {
      final response = await addInterestInPromotion(Id);
    }

    removeInterest(String Id) async {
      final response = await removeInterestInPromotion(Id);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 330,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.promotionModel.thumbnail != null
                          ? NetworkImage(widget.promotionModel.thumbnail!)
                          : AssetImage("assets/images/event_bg.png")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  // left: (MediaQuery.of(context).size.width ) / 2,
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.white.withOpacity(0.0)
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 38.sp,
                                height: 38.sp,
                                padding:
                                EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                                child: Center(
                                  child: Icon(Icons.arrow_back_ios_new, size: 15.sp),
                                ),
                                decoration: BoxDecoration(
                                  color: appBarIcon,
                                  border: Border.all(
                                    color: Color(0xffDDC9BB),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Event Details",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                // color: Color(0xff333333),
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 330.w) / 2,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    width: 330.w,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff5A5A5A1A),
                            blurRadius: 20,
                            offset: Offset(
                              0,
                              0,
                            ),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25.r))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/people_going.png",
                              scale: 3,
                            ),
                            SizedBox(
                              width: 9.sp,
                            ),
                            Text(
                              "${widget.promotionModel.interesteds!.length > 0 ? "+" : ""}${interestedLength ?? 0} Going",
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            var response;
                            if (interest == false) {
                              await addInterestInPromotion(
                                  widget.promotionModel.id!);
                            } else {
                              await removeInterestInPromotion(
                                  widget.promotionModel.id!);
                            }
                            ref.refresh(
                                fetchSinglePromotion(widget.promotionModel.id!)
                                    .future);
                            ref.read(refreshInterestedList)(context);
                            // ref.refresh(getAllPromotions);
                            setState(() {
                              interest = !interest;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              color: interest
                                  ? Color(0xff15B756)
                                  : Color(0xff282829),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              interest ? "Remove interest" : "Interested",
                              style: GoogleFonts.poppins(
                                color: Color(0xffEDEFFF),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.promotionModel.title!,
                    style: GoogleFonts.poppins(
                      fontSize: 32.sp,
                      color: Color(0xff120D26),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  infoWidget(
                    text: DateFormat("dd MMMM, yyyy").format(tempDate),
                    secondText:
                        "${DateFormat.E().format(tempDate)}, ${DateFormat.jm().format(tempDate)}",
                    imagePath: "calender",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  infoWidget(
                    text: widget.promotionModel.location!,
                    secondText: widget.promotionModel.streetLocation!,
                    imagePath: "location_grey",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "About Event",
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: Color(0xff120D26),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ReadMoreText(
                    widget.promotionModel.description!,
                    trimLines: 3,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    style: GoogleFonts.raleway(
                      color: Color(0xff6B6B6F),
                      fontSize: 16.sp,
                    ),
                    lessStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffD06F0E)),
                    trimCollapsedText: 'Read more...',
                    trimExpandedText: ' Show less',
                    moreStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffD06F0E)),
                  ),
                  SizedBox(
                    height: 16.sp,
                  ),
                  // Text(
                  //   "About Event",
                  //   style: GoogleFonts.raleway(
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: 18.sp,
                  //     color: Color(0xff120D26),
                  //   ),
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Icon(
                  //       Icons.location_on,
                  //       color: Color(0xff716E90),
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         widget.promotionModel.streetLocation!,
                  //         softWrap: true,
                  //         style: GoogleFonts.poppins(
                  //           color: Color(0xff6B6B6F),
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 14.sp,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class infoWidget extends StatelessWidget {
  const infoWidget({
    super.key,
    required this.imagePath,
    required this.text,
    required this.secondText,
  });

  final String imagePath;
  final String text;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: Color(0xffF5F5F6),
            image: DecorationImage(
              image: AssetImage("assets/images/$imagePath.png"),
              scale: 4,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Color(0xff120D26),
              ),
            ),
            Text(
              secondText,
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Color(0xff747688),
              ),
            ),
          ],
        )
      ],
    );
  }
}
