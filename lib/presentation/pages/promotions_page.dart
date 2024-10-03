import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wealth/features/promotions/models/PromotionModel.dart';
import 'package:wealth/features/promotions/requests/promotion_requests.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';

import '../font_sizes.dart';
import 'homepage.dart';

//
// final refreshHomePageProvider = Provider((ref) {
//   return (BuildContext context) async {
//     // Your data fetching logic here
//     // await ref.refresh(promotions);
//     // await ref.refresh(profileProvider.future);
//     // await ref.refresh(crowdFundList(null).future);
//   };
// });

class Promotions extends ConsumerStatefulWidget {
  const Promotions({Key? key}) : super(key: key);

  @override
  ConsumerState<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends ConsumerState<Promotions> {
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<PromotionModel> promotionsList = [];

  final refreshAllPromotions = Provider((ref) {
    return (BuildContext context) async {
      await ref.refresh(getAllPromotions);
    };
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _loadMoreData();
    //   }
    // });\
    ref.read(refreshAllPromotions)(context);
  }

  Future<void> _loadMoreData() async {
    if (!_isLoadingMore && (ref.watch(totalPageNumber) > _currentPage * 5)) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage += 1; // Increment the page number
      // Trigger the fetch for the next page
      // await ref.refresh(getAllPromotions(_currentPage).future);
      await ref.refresh(getAllPromotions.future);
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
    AsyncValue<List<PromotionModel>> promotions =
        // ref.watch(getAllPromotions(_currentPage));
        ref.watch(getAllPromotions);

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: orangeTextColor,
          backgroundColor: secondaryColor,
          onRefresh: () async {
            await ref.refresh(getAllPromotions);
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Promotions",
                    style: secondaryHeader,
                  ),
                  promotions.when(data: (data) {
                    if (data.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "No promotions currently",
                            style: secondaryText,
                          ),
                        ),
                      );
                    } else {
                      promotionsList.addAll(data);
                      return Expanded(
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: promotionsList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 10.sp,
                                  horizontal: 2,
                                ),
                                child: InkWell(
                                  child: Ink(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff505588)
                                                .withOpacity(0.1),
                                            blurRadius: 5,
                                            offset: Offset(
                                              0,
                                              2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: promotionsList[index]
                                                                .thumbnail !=
                                                            null
                                                        ? NetworkImage(
                                                            promotionsList[
                                                                    index]
                                                                .thumbnail!)
                                                        : AssetImage(
                                                                "assets/images/event_1.png")
                                                            as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.r),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                left: 10,
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.all(10.sp),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.r),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        DateFormat("MM").format(
                                                            DateFormat(
                                                                    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                                .parse(promotionsList[
                                                                        index]
                                                                    .date!)),
                                                        style:
                                                            GoogleFonts.raleway(
                                                          color:
                                                              Color(0xffF0635A),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize:
                                                              section__normal,
                                                        ),
                                                      ),
                                                      Text(
                                                        DateFormat(" MMMM")
                                                            .format(DateFormat(
                                                                    "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                                                .parse(
                                                                    promotionsList[
                                                                            index]
                                                                        .date!))
                                                            .toUpperCase(),
                                                        style:
                                                            GoogleFonts.raleway(
                                                          color:
                                                              Color(0xffF0635A),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: 400.w,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 0),
                                            child: Text(
                                              promotionsList[index].title!,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.raleway(
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                                fontSize: section__normal,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/people_going.png",
                                                    scale: 3,
                                                  ),
                                                  SizedBox(width: 10.sp),
                                                  Text(
                                                    "${promotionsList[index].interesteds!.length} Going",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12.sp),
                                                  )
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  context.push(
                                                      "/event_details/1321",
                                                      extra: promotionsList[
                                                          index]);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 10.sp,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff282829),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20.r),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "View Details",
                                                    style: GoogleFonts.poppins(
                                                      color: Color(0xffEDEFFF),
                                                      fontSize: 8.sp,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 16.sp,
                                                color: Color(0xff716E90),
                                              ),
                                              Text(
                                                promotionsList[index].location!,
                                                style: GoogleFonts.raleway(
                                                  color: Color(0xff716E90),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }, error: (error, _) {
                    return Container(
                        child: Center(
                            child: Text(
                                'Unable to fetch promotions at the moment')));
                  }, loading: () {
                    return Container(
                      child: Center(
                        child: SpinKitCubeGrid(
                          color: blackGrey,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
