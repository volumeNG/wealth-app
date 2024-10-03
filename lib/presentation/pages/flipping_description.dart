import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wealth/features/flipping/models/FlippingModel.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/property_description.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:readmore/readmore.dart';
import 'package:wealth/presentation/pages/widgets/current_desc.dart';
import 'package:wealth/presentation/pages/widgets/user_login_popup.dart';

import '../../features/flipping/requests/flipping_requests.dart';
import '../colors.dart';

class FlippingDesc extends ConsumerStatefulWidget {
  const FlippingDesc({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  ConsumerState<FlippingDesc> createState() => _FlippingDescState();
}

class _FlippingDescState extends ConsumerState<FlippingDesc> {
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
  Widget build(BuildContext context) {
    bool seller = false;

    final width = MediaQuery.of(context).size.width;
    final AsyncValue<FlippingModel> propertyDetails =
        ref.watch(singleFlippingProperty(widget.id));
    propertyDetails.when(
      data: (data) {
        seller = ref.read(profile_Provider.notifier).state.id == data.ownById;
      },
      error: (error, _) => {},
      loading: () => {},
    );

    // Update UI state here (moved outside the when block)
    setState(() {});

    return Scaffold(
      bottomNavigationBar: Container(
        // height: MediaQuery.of(context).size.height * 0.08,
        height: (MediaQuery.of(context).size.height * 0.08) + 20,
        color: Colors.transparent,

        // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        child: seller == true
            ? SizedBox.shrink()
            : Container(
                color: Colors.transparent,
                // height: (MediaQuery.of(context).size.height * 0.08) + 20,
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: BTN(
                  width: width,
                  text: "Purchase",
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
                      ref.read(payment_provider.notifier).state.type =
                          "flipping";
                      ref.read(payment_provider.notifier).state.id = widget.id;
                      //  Display we have noted down your request part
                      context.push("/payment_made");
                    }
                  },
                ),
              ),
      ),
      backgroundColor: Colors.white,
      body: propertyDetails.when(
        data: (data) {
          // seller = ref.read(profile_Provider.notifier).state.id == data.ownById;
          // setState(() {
          //   seller =
          //       ref.read(profile_Provider.notifier).state.id == data.ownById;
          // });
          //
          // setState(() {});
          return ListView(
            children: [
              Container(
                height: 300,
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
                    CurrentDescText(
                      width: width,
                      location: data.location ?? "",
                      property: data.title!,
                      price: data.price!,
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
                      height: 20,
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
                      height: 5,
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffD06F0E)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Location",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff282829),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: greenIcon,
                        ),
                        SizedBox(
                          width: 5,
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
                      height: 20,
                    ),
                    Text(
                      "Property Video",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff282829),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Stack(
                    //   children: [
                    //     Container(
                    //       height: 200,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(20.r),
                    //         ),
                    //         image: DecorationImage(
                    //           image: NetworkImage(
                    //             data.thumbnail!,
                    //           ),
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       // left: MediaQuery.of(context).size.width / 2,
                    //       child: Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         height: 200,
                    //         color: Colors.transparent,
                    //         child: InkWell(
                    //           onTap: () => _launchYoutubeVideo(data.videoUrl!),
                    //           child: ImageIcon(
                    //             AssetImage(
                    //               "assets/images/small_play.png",
                    //             ),
                    //             size: 10,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

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
                      height: 20,
                    ),
                    Text(
                      "Property Images",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff282829),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                    // Container(
                    //   height: 350,
                    //   child: data.images!.length != 0
                    //       ? GridView.count(
                    //           crossAxisSpacing: 20.0,
                    //           mainAxisSpacing: 10.0,
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
                    //                     Radius.circular(20.r),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         )
                    //       : SizedBox.shrink(),
                    // ),
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
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpinKitCubeGrid(
                      size: 20,
                      color: Color(0xff828282),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
