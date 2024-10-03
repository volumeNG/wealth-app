import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wealth/features/flipping/models/FlippingModel.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/flipping/requests/flipping_requests.dart';
import '../colors.dart';
import '../font_sizes.dart';
import 'components/specific_property.dart';
import 'homepage.dart';

class Flipping extends ConsumerStatefulWidget {
  const Flipping({Key? key}) : super(key: key);

  @override
  ConsumerState<Flipping> createState() => _FlippingState();
}

class _FlippingState extends ConsumerState<Flipping> {
  late final formattedNumber = NumberFormat('#,###,###').format(5500000);
  int _currentPage = 1;

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<FlippingModel> _flippingModelList = [];

  // formattedNumber.toString(),

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (!_isLoadingMore && (ref.watch(totalPageNumber) > _currentPage * 5)) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage += 1; // Increment the page number
      // Trigger the fetch for the next page
      await ref.refresh(getAllFlippingProperty(_currentPage).future);
      setState(() {
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        // limitReached = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<FlippingModel>> propertyFlipped =
        ref.watch(getAllFlippingProperty(_currentPage));

    final width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // "Flipping(Buy/Sell)",
                "Flipping",
                style: secondaryHeader,
              ),
              // noListing(), This is for if the account flipping is empty

              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/flipping_bg.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(20.r))),
                child: Column(
                  children: [
                    Text(
                      "Upload a new Project for sale",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 12.sp),
                    ),
                    SizedBox(height: 8.sp),
                    InkWell(
                      onTap: () {
                        context.push("/flipping");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xffF5F5F6),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r))),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.sp, horizontal: 20.sp),
                        child: Text(
                          "List Property",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff282829),
                              fontSize: 14.sp),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              propertyFlipped.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          "No property listed",
                          style: secondaryText,
                          // style: GoogleFonts.raleway(
                          //   fontSize: 18.sp,
                          //   color: Colors.black,
                          //   fontWeight: FontWeight.w600,
                          // ),
                        ),
                      ),
                    );
                  } else {
                    if (_flippingModelList.length <
                        ref.watch(totalPageNumber.notifier).state) {
                      for (var item in data) {
                        if (!_flippingModelList.contains(item)) {
                          _flippingModelList.add(item);
                        }
                      }
                    } else {}
                    return Expanded(
                      // height: MediaQuery.of(context).size.height * 0.614,
                      // color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Listed Property",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: text__normal,
                            ),
                          ),
                          SizedBox(
                            height: 3.sp,
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: _flippingModelList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: propertyListing(
                                    saveType: "flipping",
                                    onTap: () {
                                      context.push(
                                          "/flipping_desc/${_flippingModelList[index].id}");
                                    },
                                    thumbnail:
                                        _flippingModelList[index].thumbnail!,
                                    width: width,
                                    id: _flippingModelList[index].id!,
                                    propertyName:
                                        _flippingModelList[index].title!,
                                    location:
                                        _flippingModelList[index].location!,
                                    propertySize:
                                        _flippingModelList[index].size!,
                                    propertyType:
                                        _flippingModelList[index].type!,
                                    roomNumber: _flippingModelList[index].rooms,
                                    propertyPrice:
                                        _flippingModelList[index].price,
                                  ),
                                );
                              },
                            ),
                          ),
                          _isLoadingMore
                              ? SpinKitCubeGrid(
                                  size: 20,
                                  color: blackGrey,
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    );
                  }
                },
                error: (error, _) {
                  return Container(
                    child: Center(
                      child: Text("Unable to fetch data"),
                    ),
                  );
                },
                loading: () {
                  return Container(
                    child: Center(
                      child: SpinKitCubeGrid(
                        color: blackGrey,
                        size: 20,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class noListing extends StatelessWidget {
  const noListing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            // padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Color(0xff4B4B4E).withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(100.r))),
            child: Center(
              child: Text(
                "0",
                style: GoogleFonts.poppins(
                    wordSpacing: 0,
                    color: Color(0xff4B4B4E),
                    fontWeight: FontWeight.w600,
                    fontSize: 72.sp),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "You have no flipped property",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Your flipping (Buy/Sell) page is empty. you can add new home,apartment land or villa here to sell.",
            softWrap: true,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Color(0xff6B6B6F),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/flipping_bg.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(20.r))),
            child: Column(
              children: [
                Text(
                  "Upload a new Project for sale",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 12.sp),
                ),
                SizedBox(height: 8.sp),
                InkWell(
                  onTap: () {
                    context.push("/flipping");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF5F5F6),
                        borderRadius: BorderRadius.all(Radius.circular(5.r))),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.sp, horizontal: 20.sp),
                    child: Text(
                      "List Property",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff282829),
                          fontSize: 14.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
