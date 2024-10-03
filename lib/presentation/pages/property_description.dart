import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wealth/features/crowd_funding/requests/crowd_funding.dart';
import 'package:wealth/features/current_locations/models/property_state.dart';
import 'package:wealth/features/current_locations/requests/current_locations_requests.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/payment_page.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/current_desc.dart';
import 'package:wealth/presentation/pages/widgets/project_desc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:wealth/presentation/pages/widgets/user_login_popup.dart';
import '../../features/crowd_funding/models/Property.dart';
import '../colors.dart';

Future<void> _initialize() async {
  await Future.delayed(const Duration(milliseconds: 500));
}

class PropertyDescription extends ConsumerStatefulWidget {
  const PropertyDescription(
      {Key? key, required this.id, this.type = "homepage"})
      : super(key: key);

  final String id;
  final String? type;

  @override
  ConsumerState<PropertyDescription> createState() =>
      _PropertyDescriptionState();
}

class _PropertyDescriptionState extends ConsumerState<PropertyDescription> {
  bool disabled = true;

  Future<void> _launchYoutubeVideo(String _youtubeUrl) async {
    if (_youtubeUrl != null && _youtubeUrl.isNotEmpty) {
      if (await canLaunch(_youtubeUrl)) {
        final bool _nativeAppLaunchSucceeded = await launch(
          _youtubeUrl,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        if (!_nativeAppLaunchSucceeded) {
          await launch(_youtubeUrl, forceSafariVC: true);
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(seconds: 1);
    const Curve curve = Curves.fastOutSlowIn;

    final width = MediaQuery.of(context).size.width;
    var targetFund = 0;
    var fundRaised = 0;
    AsyncValue<Property> propertyDetails;
    AsyncValue<List<PropertyData>>?
        propertyState; // Declare propertyState as nullable

    if (widget.type == "homepage") {
      propertyDetails = ref.watch(singleProperty(widget.id));
      // propertyState will remain null for homepage type
    } else if (widget.type == "current") {
      propertyDetails = ref.watch(singleCurrentProperty(widget.id));
      propertyState = ref.watch(getPropertyState(widget.id));
    } else {
      propertyDetails = ref.watch(singleProperty(widget.id));
    }

    return Scaffold(
      bottomNavigationBar: FutureBuilder(
        future: _initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink(); // or a loading indicator
          } else {
            return Container(
              color: Colors.transparent,
              height: (MediaQuery.of(context).size.height * 0.08) + 20,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: BTN(
                width: width,
                // disabled: disabled,
                text: widget.type == "current"
                    ? "Purchase"
                    : "To Fund Click Here",
                onTap: () async {
                  var doesAccessExist =
                      await storage.readSecureData("accessToken");
                  if (doesAccessExist != null &&
                      doesAccessExist == "No data found!") {
                    ///TODO: This is the section that would need the pop up as there is not a user currently logged in.
                    showDialog(
                      context: context,
                      builder: (context) => UserLoginPopup(),
                    );
                  } else {
                    if (ref.read(profile_Provider.notifier).state.name !=
                            null ||
                        ref
                            .read(profile_Provider.notifier)
                            .state
                            .name!
                            .isNotEmpty) {}
                    setState(() {
                      disabled = true;
                    });
                    ref.read(payment_provider.notifier).state.type =
                        widget.type!;
                    ref.read(payment_provider.notifier).state.id = widget.id;
                    ref.read(totalAmount.notifier).state = targetFund;
                    ref.read(totalAmountLeft.notifier).state =
                        targetFund - fundRaised;
                    context.push("/initial_paypage/${widget.type}");
                    setState(() {
                      disabled = false;
                    });
                  }
                },
              ),
            );
          }
        },
      ),
      backgroundColor: Colors.white,
      body: propertyDetails.when(
        data: (data) {
          if (data.targetFund != null) {
            targetFund = data.targetFund!;
            fundRaised = data.fundRaised!;
          }
          return ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.46,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: data.thumbnail!.isEmpty
                          ? AssetImage("assets/images/house.png")
                          : NetworkImage(data.thumbnail!) as ImageProvider,
                      fit: BoxFit.cover),
                ),
                child: Text(""),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.type != "current"
                        ? ProjectDescText(
                            width: width,
                            initial: false,
                            location: data.location?.name ?? "",
                            property: data.title!,
                            fundRaised: data.fundRaised! ?? 0,
                            targetFund: data.targetFund!)
                        : CurrentDescText(
                            width: width,
                            location: data.location?.name ?? "",
                            property: data.title!,
                            price: data.price,
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            ImageIcon(
                              AssetImage("assets/images/metric.png"),
                              color: greenIcon,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data.size!} m",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff4E4F50),
                                      fontSize: 14.sp),
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
                        SizedBox(
                          width: 20,
                        ),
                        data.floor != null
                            ? Row(
                                children: [
                                  ImageIcon(
                                    AssetImage("assets/images/floors.png"),
                                    color: greenIcon,
                                  ),
                                  Text(
                                    "${data.floor.toString()} Floor",
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
                      height: 16.sp,
                    ),
                    Text(
                      "Property overview",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff282829),
                      ),
                    ),
                    SizedBox(
                      height: 8.sp,
                    ),
                    ReadMoreText(
                      data.description!,
                      trimLines: 3,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      style: GoogleFonts.poppins(
                        color: Color(0xff6B6B6F),
                        fontSize: 14.sp,
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
                      height: 24.sp,
                    ),
                    Text(
                      "Location",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff282829),
                      ),
                    ),
                    SizedBox(
                      height: 8.sp,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: greenIcon,
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        Text(
                          data.streetLocation!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff6B6B6F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24.sp,
                    ),
                    Text(
                      "Property Video",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff282829),
                      ),
                    ),
                    SizedBox(
                      height: 8.sp,
                    ),
                    InkWell(
                      onTap: () => _launchYoutubeVideo(data.videoUrl!),
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.1,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.sp, vertical: 22.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.sp, vertical: 10.sp),
                          decoration: BoxDecoration(
                            color: Color(0xffC07D1F),
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage(
                                  "assets/images/small_play.png",
                                ),
                                size: 40.sp,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8.sp,
                              ),
                              Text(
                                "Watch Project Video",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.sp,
                    ),
                    Text(
                      "Property Images",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff282829),
                      ),
                    ),
                    SizedBox(
                      height: 8.sp,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      child: Container(
                        // height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: ImageSliderDemo(
                          imgList: data.images!,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 8.sp,
                    // ),
                    // Container(
                    //   child: data.images!.length != 0
                    //       ? GridView.count(
                    //           crossAxisSpacing: 19.sp,
                    //           mainAxisSpacing: 12.sp,
                    //           physics: NeverScrollableScrollPhysics(),
                    //           crossAxisCount: 2,
                    //           controller:
                    //               ScrollController(keepScrollOffset: false),
                    //           shrinkWrap: true,
                    //           children: List.generate(
                    //             data.images!.length,
                    //             (index) {
                    //               return Container(
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.brown,
                    //                   image: DecorationImage(
                    //                     image: data.images![index].isEmpty
                    //                         ? AssetImage(
                    //                             "assets/images/house.png")
                    //                         : NetworkImage(data.images![index])
                    //                             as ImageProvider,
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                   borderRadius: BorderRadius.all(
                    //                     Radius.circular(10.r),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         )
                    //       : SizedBox.shrink(),
                    // ),
                    SizedBox(
                      height: 24.sp,
                    ),
                    widget.type != "current"
                        ? SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Property Chart",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff282829),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              propertyState != null
                                  ? propertyState.when(
                                      data: (data) {
                                        if (data.isNotEmpty) {
                                          return Container(
                                              height: 250,
                                              child: PriceChart(
                                                data: data,
                                              ));
                                        } else {
                                          return Text(
                                            "No change in the property state",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                color: secondaryTextColor),
                                          );
                                        }
                                      },
                                      error: (error, _) {
                                        return Container(
                                          child: Center(
                                            child: Text(
                                                "Unable to fetch chart data"),
                                          ),
                                        );
                                      },
                                      loading: () {
                                        return Container(
                                          child: Center(
                                            child: SpinKitCubeGrid(
                                              size: 20,
                                              color: blackGrey,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox.shrink()
                            ],
                          )
                  ],
                ),
              )
            ],
          );
        },
        error: (error, _) {
          return Center(
            child: Text("Unable to fetch data"),
          );
        },
        loading: () {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitCubeGrid(
                  size: 20,
                  color: blackGrey,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Wait",
                  style: GoogleFonts.poppins(
                    color: Color(0xff828282),
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class PriceChart extends StatelessWidget {
  const PriceChart({Key? key, required this.data}) : super(key: key);

  final List<PropertyData> data;

  @override
  Widget build(BuildContext context) {
    List<FlSpot>? chartData = data
        ?.asMap()
        .map((index, item) => MapEntry(
              index,
              FlSpot(
                index.toDouble(),
                item.price!.toDouble(),
              ),
            ))
        .values
        .toList();

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: chartData,
              isCurved: true,
              colors: [Color(0xff15B756)],
              curveSmoothness: 0.3,
              barWidth: 2,
              isStrokeCapRound: true,

              // belowBarData: BarAreaData(show: false),
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  Color(0xff15B756).withOpacity(0.4),
                  Color(0xff15B756).withOpacity(0.2),
                  Colors.transparent
                ], // Set fill color
              ),
            ),
          ],
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: false,
              getTitles: (value) {
                // Assuming data is sorted by time
                if (value.toInt() >= 0 && value.toInt() < data!.length) {
                  var item = data?[value.toInt()];
                  // return item['time'].substring(8, 10);
                  if (item != null) {
                    return item.time!.substring(0, 10);
                  } else {
                    return "";
                  }
                }
                return '';
              },
            ),
            leftTitles: SideTitles(
              showTitles: false,
              // getTitles: (value){
              //
              //   if (value.toInt() >= 0 && value.toInt() < data!.length) {
              //     var item = data?[value.toInt()];
              //     // return item['time'].substring(8, 10);
              //     // print(data[value.toInt()].price.toString());
              //     // return data[value.toInt()].price.toString();
              //     if (item != null) {
              //       return item.time!.substring(0, 10);
              //     } else {
              //       return "";
              //     }
              //   }
              //   return '';
              //
              // }
            ),
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(color: Colors.grey),
          ),
          gridData: FlGridData(
            show: false, // Remove grid lines
            // drawHorizontalLine: true,
            // drawVerticalLine: true,
            // horizontalInterval: 1,
            // Frequency of horizontal grid lines
            // verticalInterval: 1,
            // Frequency of vertical grid lines
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.1), // Lighter grid line color
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.1), // Lighter grid line color
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }
}

class ImageSliderDemo extends StatelessWidget {
  const ImageSliderDemo({
    super.key,
    required this.imgList,
  });

  final List<dynamic> imgList;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        height: 250,
        autoPlay: true,
        // aspectRatio: 2.0,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        enlargeFactor: 0.4,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        enlargeCenterPage: false,
        clipBehavior: Clip.hardEdge,
      ),
      items: imgList
          .map((item) => Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(item),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Center(
                //   child: Image.network(item, fit: BoxFit.cover, width: 1000),
                // ),
              ))
          .toList(),
    ));
  }
}


