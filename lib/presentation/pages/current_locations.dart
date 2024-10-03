import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/features/current_locations/requests/current_locations_requests.dart';
import 'package:wealth/presentation/font_sizes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import 'package:wealth/features/current_locations/models/location.dart';

import '../colors.dart';
import 'homepage.dart';

class CurrentLocation extends ConsumerStatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  ConsumerState<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends ConsumerState<CurrentLocation> {
  final minPrice = TextEditingController();
  final maxPrice = TextEditingController();
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<CurrentLocationModel> currentLocationsList = [];


  String dropdownValue = 'all';
  List<String> dropDownList = [
    "all",
    "land",
    "semiDetachedHouse",
    "detachedHouse",
    "finished",
    "unFinished"
  ];

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
      await ref.refresh(getLocations(_currentPage).future);
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // ref.invalidate(getLocations);
  }


  @override
  Widget build(BuildContext context) {
    AsyncValue<List<CurrentLocationModel>> currentLocations =
        ref.watch(getLocations(_currentPage));
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: RefreshIndicator(
        color: orangeTextColor,
        backgroundColor: secondaryColor,
        onRefresh: () async {
          setState(() {
            _currentPage = 1;
          });
          await Future.delayed(Duration(seconds: 2));
          await ref.refresh(getLocations(_currentPage));
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current Locations",
                      style: secondaryHeader,
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.sp,
                ),
                Expanded(
                    child: currentLocations.when(data: (data) {
                  if (currentLocationsList.length <
                      ref.watch(totalPageNumber.notifier).state) {
                    for (var item in data) {
                      if (!currentLocationsList.contains(item)) {
                        currentLocationsList.add(item);
                      }
                    }
                    // currentLocationsList.addAll(data);
                  } else {}
                  return ListView.builder(
                      controller: _scrollController,
                      itemCount: currentLocationsList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.push(
                                '/specific_property/${currentLocationsList[index].id}/${currentLocationsList[index].name}');
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.sp, horizontal: 0),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: blackGrey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    image: DecorationImage(
                                      image: currentLocationsList[index]
                                                      ?.imgUrl !=
                                                  null &&
                                              currentLocationsList[index]
                                                  .imgUrl!
                                                  .isNotEmpty
                                          ? NetworkImage(
                                              currentLocationsList[index]
                                                  .imgUrl!)
                                          : NetworkImage(
                                              'https://picsum.photos/250?image=9'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 17.sp,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: currentLocationsList[index].name!,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: text__md,
                                        color: Color(0xff282829)),
                                    children: [
                                      TextSpan(
                                          text: " " +
                                              currentLocationsList[index]
                                                  .cCount!
                                                  .property
                                                  .toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }, error: (error, _) {
                  return Center(
                    child: Text("unable to fetch data"),
                  );
                }, loading: () {
                  return SpinKitCubeGrid(
                    size: 20,
                    color: blackGrey,
                  );
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MinMaxPrice extends StatelessWidget {
  const MinMaxPrice({
    super.key,
    required this.width,
    required this.controller,
    required this.label,
  });

  final double width;
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Color(0xff444446),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          height: 50,
          width: width * 0.43,
          child: TextFormField(
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: controller,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Color(0xff4E4F50),
              fontSize: width * 0.04,
            ),
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              print(value);
            },
            cursorColor: softBlack,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: blackGrey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: softBlack,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class bottomButton extends StatelessWidget {
  const bottomButton({
    super.key,
    required this.width,
    required this.text,
    required this.black,
    required this.onTap,
  });

  final double width;
  final String text;
  final bool black;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width * 0.43,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: black ? Color(0xff282829) : Colors.white,
          border: Border.all(
            width: 1,
            color: Color(0xffD0D0D1),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15.r),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: black ? Colors.white : Color(0xff282829),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
