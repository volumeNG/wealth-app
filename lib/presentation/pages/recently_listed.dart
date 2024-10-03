import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/project_desc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/widgets/user_login_popup.dart';
import 'package:wealth/utilities.dart';
import '../../features/crowd_funding/models/Property.dart';
import '../../features/crowd_funding/requests/crowd_funding.dart';
import 'current_locations.dart';

class RecentlyListedPage extends ConsumerStatefulWidget {
  const RecentlyListedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RecentlyListedPage> createState() => _RecentlyListedPageState();
}

class _RecentlyListedPageState extends ConsumerState<RecentlyListedPage> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  final minPrice = TextEditingController();
  final maxPrice = TextEditingController();
  CrowdFundFilter _crowdFundFilter = CrowdFundFilter();
  String dropdownValue = 'land';
  List<String> dropDownList = [
    "land",
    "semiDetachedHouse",
    "detachedHouse",
    "finished",
    "unFinished"
  ];
  List<Property> propertiesList = [];

  Timer? _debounce;
  int _currentPage = 1;

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool visited = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeControllers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    propertiesList = [];
    super.dispose();
  }

  initializeControllers() async {
    minPrice.text = "0";
    maxPrice.text = "0";
  }

  Future<void> _loadMoreData() async {
    if (!_isLoadingMore && (ref.watch(totalPageNumber) > _currentPage * 5)) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage += 1; // Increment the page number
      // Trigger the fetch for the next page
      await ref.refresh(
          crowdFundList(Tuple2(_crowdFundFilter, _currentPage)).future);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void onValueChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      // setState(() {
      //   _crowdFundFilter.title = value;
      //
      //   _currentPage = 1; // Reset to the first page when search changes
      // });
      setState(() {
        _crowdFundFilter.title = value;
        _currentPage = 1; // Reset to the first page when search changes
        propertiesList.clear(); // Clear propertiesList when search changes
      });
      if (_crowdFundFilter.title!.isEmpty) {
        setState(() {
          visited = true;
        });
      }
      ref.refresh(crowdFundList(Tuple2(_crowdFundFilter, _currentPage)));
      // if (_crowdFundFilter.title!.isEmpty) {
      //   propertiesList = [];
      //   limitReached = false;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    AsyncValue<List<Property>> properties =
        ref.watch(crowdFundList(Tuple2(_crowdFundFilter, _currentPage)));

    Future<void> fetchFilteredList(CrowdFundFilter filter) async {
      _currentPage = 1; // Reset to the first page when filters change
      ref.refresh(crowdFundList(Tuple2(filter, _currentPage)));
    }

    Future<void> clearFilter(CrowdFundFilter filter) async {
      setState(() {
        _currentPage = 1; // Reset page number
        dropdownValue = "land";
      });
      ref.refresh(crowdFundList(Tuple2(filter, _currentPage)));
    }

    properties.when(
      data: (data) {
        setState(() {
          _isLoadingMore = false;
          // if (data.isNotEmpty && _crowdFundFilter.title!.isEmpty) {
          //   propertiesList.clear(); // Clear list only when new data arrives and search term is empty
          // }
        });
        if (data.isNotEmpty && _crowdFundFilter.title!.isEmpty) {
          // if (limitReached) {
          //   return;
          // }

          //It still fetches the one
          // setState(() {
          //   // Merge the lists, then convert to a set to remove duplicates, and back to a list
          //   final existingIds =
          //       propertiesList.map((property) => property.id).toSet();
          //
          //   for (var item in data) {
          //     // if (!existingIds.contains(item.id)) {
          //     // existingIds.add(item.id);
          //     // }
          //   }
          // });

          if (propertiesList.length <
              ref.watch(totalPageNumber.notifier).state) {
            for (var item in data) {
              if (!propertiesList.contains(item)) {
                propertiesList.add(item);
              }
            }
            if (visited) {
              propertiesList.clear();
              setState(() {
                visited = false;
                _isLoadingMore = true;
              });
            }
            // propertiesList.addAll(data);
          }
        } else {
          propertiesList.clear();
          // propertiesList.addAll(data);
          if (propertiesList.length <
              ref.watch(totalPageNumber.notifier).state) {
            propertiesList.addAll(data);
          }
        }
      },
      error: (error, _) {
        print(error);
        setState(() {
          _isLoadingMore = false;
        });
      },
      loading: () {
        setState(() {
          _isLoadingMore = true;
        });
      },
    );

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: Ink(
                        child: Row(
                          children: [
                            Container(
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
                                      BorderRadius.all(Radius.circular(40))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        // width: width * 0.7,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          border: Border.all(
                            width: 1,
                            color: Color(0x14000000),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            Form(
                              key: _formKey,
                              child: Expanded(
                                child: TextFormField(
                                  onChanged: onValueChanged,
                                  onTapOutside: (PointerDownEvent event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  cursorColor: Colors.black54,
                                  controller: searchController,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    // prefixIcon: ImageIcon(
                                    //   AssetImage("assets/images/search.png"),
                                    //   size: 14,
                                    // ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 24.sp,
                                      color: Colors.black,
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    hintText: "Search location",
                                    hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Color(0xff86868A),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.all(20),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Filter",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff222222),
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "Property Type",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff222222),
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Color(0xffDDDDDD),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: StatefulBuilder(
                                                  builder: (BuildContext
                                                          context,
                                                      StateSetter setState) {
                                                    return DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        icon: Icon(Icons
                                                            .keyboard_arrow_down_sharp),
                                                        isExpanded: false,
                                                        isDense: true,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff444446),
                                                        ),
                                                        dropdownColor:
                                                            Color(0xffccc5c5),
                                                        // orangeTextColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                        elevation: 15,
                                                        value: dropdownValue,
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            dropdownValue =
                                                                newValue!;
                                                          });
                                                        },
                                                        items: dropDownList.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                          (String value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                formatDropdownString(
                                                                  value,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Price Range",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff222222),
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  MinMaxPrice(
                                                    width: width,
                                                    controller: minPrice,
                                                    label: "Min",
                                                  ),
                                                  MinMaxPrice(
                                                    width: width,
                                                    controller: maxPrice,
                                                    label: "Max",
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              bottomButton(
                                                width: width,
                                                text: "Clear All",
                                                onTap: () async {
                                                  setState(() {
                                                    minPrice.text = "";
                                                    maxPrice.text = "";
                                                    dropdownValue = "all";
                                                    searchController.text = "";
                                                    _crowdFundFilter.title = "";
                                                    _crowdFundFilter.type =
                                                        null;
                                                    _crowdFundFilter.maxPrice =
                                                        0;
                                                    _crowdFundFilter.minPrice =
                                                        0;
                                                  });

                                                  await clearFilter(
                                                      _crowdFundFilter);
                                                  Navigator.pop(context);
                                                },
                                                black: false,
                                              ),
                                              bottomButton(
                                                width: width,
                                                text: "Apply Filters",
                                                black: true,
                                                onTap: () async {
                                                  setState(() {
                                                    _crowdFundFilter.title =
                                                        searchController.text;
                                                    _crowdFundFilter.type =
                                                        dropdownValue;
                                                    _crowdFundFilter.maxPrice =
                                                        maxPrice.text.isNotEmpty
                                                            ? int.parse(
                                                                maxPrice.text)
                                                            : null;
                                                    _crowdFundFilter.minPrice =
                                                        minPrice.text.isNotEmpty
                                                            ? int.parse(
                                                                minPrice.text)
                                                            : null;
                                                  });
                                                  await fetchFilteredList(
                                                      _crowdFundFilter);
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0x14000000),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: ImageIcon(
                                  AssetImage("assets/images/settings.png"),
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              propertiesList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: propertiesList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 0,
                                      top: 10,
                                      left: 0,
                                      bottom: 0,
                                    ),
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      image: DecorationImage(
                                        image: propertiesList[index]
                                                    .thumbnail !=
                                                null
                                            ? NetworkImage(propertiesList[index]
                                                .thumbnail!)
                                            : AssetImage(
                                                    "assets/images/house.png")
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    top: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.88),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: IconButton(
                                        onPressed: () async {
                                          var response = await saveProperty(
                                              propertiesList[index].id!);
                                          final res = response["data"];
                                          if (response["success"]) {
                                            setState(() {
                                              propertiesList[index].isFavorite =
                                                  true; // Toggle favorite
                                            });
                                          } else if (response["message"]
                                                  .toString()
                                                  .toLowerCase() ==
                                              "Already Saved".toLowerCase()) {
                                            setState(() {
                                              propertiesList[index].isFavorite =
                                                  true; // Toggle favorite
                                            });
                                          } else {
                                            showErrorDialog(
                                                context, "Unable to save");
                                          }
                                          // widget.width = 100;
                                        },
                                        icon: Icon(
                                          color:
                                              propertiesList[index].isFavorite
                                                  ? Color(0xffD06F0E)
                                                  : Color(0xffE1E0DF),
                                          Icons.bookmark,
                                          size: 30,
                                        ),
                                        padding: EdgeInsets.all(0),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 20,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Text(
                                        propertiesList[index].type!,
                                        style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff282829)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ProjectDescText(
                                  width: width,
                                  location:
                                      propertiesList[index].location?.name! ??
                                          "",
                                  property: propertiesList[index].title!,
                                  rooms: propertiesList[index].rooms,
                                  floor: propertiesList[index].floor,
                                  size: propertiesList[index].size!,
                                  fundRaised: propertiesList[index].fundRaised!,
                                  targetFund:
                                      propertiesList[index].targetFund!),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                color: Colors.transparent,
                                height:
                                    (MediaQuery.of(context).size.height * 0.08),
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 10),
                                child: BTN(
                                  width: width * 0.95,
                                  onTap: () async {
                                    var doesAccessExist = await storage
                                        .readSecureData("accessToken");
                                    if (doesAccessExist != null &&
                                        doesAccessExist == "No data found!") {
                                      ///TODO: This is the section that would need the pop up as there is not a user currently logged in.
                                      showDialog(
                                        context: context,
                                        builder: (context) => UserLoginPopup(),
                                      );
                                    } else {
                                      context.push("/property/" +
                                          propertiesList[index].id! +
                                          "/homepage");
                                    }
                                  },
                                  text: "To Fund Click here",
                                  full: true,
                                ),
                              ),
                              SizedBox(
                                height: 24.sp,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : _isLoadingMore
                      ? SizedBox.shrink()
                      : Center(
                          child: Text(
                            "No property found",
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
              _isLoadingMore
                  ? Center(
                      child: SpinKitCubeGrid(
                        color: blackGrey,
                        size: 20,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
