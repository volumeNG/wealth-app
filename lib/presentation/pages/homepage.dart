import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/features/crowd_funding/models/Property.dart';
import 'package:wealth/features/crowd_funding/models/RecentlyFunded.dart';
import 'package:wealth/features/crowd_funding/requests/crowd_funding.dart';
import 'package:wealth/features/profile/model/profile.dart';
import 'package:wealth/features/profile/requests/requests.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/app_drawer.dart';
import 'package:wealth/presentation/pages/widgets/project_desc.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/widgets/user_login_popup.dart';
import '../../storage/secure_storage.dart';
import '../../utilities.dart';
import '../colors.dart';
import '../font_sizes.dart';
import 'package:tuple/tuple.dart';

final totalPageNumber = StateProvider<int>((ref) => 0);
SecureStorage storage = SecureStorage();

class PaymentProvider {
  late String type;
  late String id;
  late String fundLeft;
  String? bankId;
// late
}

final refreshHomePageProvider = Provider((ref) {
  return (BuildContext context) async {
    // Your data fetching logic here
    // var doesAccessExist = await _storage.readSecureData("accessToken");
    // if (doesAccessExist != null && doesAccessExist == "No data found!") {
    try {
      await ref.refresh(profileProvider);
      await ref.refresh(profileProvider.future);
      await ref.refresh(getRecentlyFunded.future);
      // await ref.refresh(crowdFundList(null).future);
      await ref.refresh(crowdFundList(Tuple2(null, 1)).future);
    } catch (ex) {
      print("Error: $ex this is annoying");
    }
    // }
  };
});

final profile_Provider = StateProvider<Profile>((ref) => Profile());

// final refreshProfile = Provider((ref) {
//   return (BuildContext context) async {
//     await ref.refresh(profileProvider);
//   };
// });

final payment_provider =
    StateProvider<PaymentProvider>((ref) => PaymentProvider());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Profile> user_profile = ref.watch(profileProvider);
    final AsyncValue<List<Property>> properties =
        ref.watch(crowdFundList(const Tuple2(null, 1)));
    final AsyncValue<List<RecentlyFunded>> recentlyFunded =
        ref.watch(getRecentlyFunded);
    final width = MediaQuery.of(context).size.width;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    void openDrawer() {
      _scaffoldKey.currentState?.openDrawer();
    }

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }

    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        return onBackButtonPressed(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        body: RefreshIndicator(
          color: orangeTextColor,
          backgroundColor: secondaryColor,
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            await ref.refresh(profileProvider);
            await ref.refresh(crowdFundList(Tuple2(null, 1)));
          },
          child: SafeArea(
            // top: true,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(60.sp)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(60.sp)),
                                    child: Center(
                                      child: user_profile.when(
                                        data: (data) {
                                          return data.profileImg != null
                                              ? Image.network(
                                                  data.profileImg!,
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                )
                                              : Image.asset(
                                                  "assets/images/logo.jpg",
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                );
                                        },
                                        error: (error, _) {
                                          return InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    UserLoginPopup(),
                                              );
                                            },
                                            child: Image.asset(
                                              "assets/images/logo.jpg",
                                              fit: BoxFit.cover,
                                              width: 50,
                                              height: 50,
                                            ),
                                          );
                                        },
                                        loading: () {
                                          return CircularProgressIndicator(
                                            color: linkTextOrange,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: text__sm,
                                    color: Color(0xff6B6B6F),
                                  ),
                                ),
                                user_profile.when(
                                  data: (data) {
                                    Future(() {
                                      ref
                                          .read(profile_Provider.notifier)
                                          .state = data;
                                    });

                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        data.name ?? "Sign In",
                                        overflow: TextOverflow.ellipsis,
                                        style: homeHeader,
                                      ),
                                    );
                                  },
                                  error: (error, _) {
                                    return Container(
                                      child: Text(
                                        "Please Sign In",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff525257),
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () {
                                    return SpinKitChasingDots(
                                      size: 20,
                                      color: blackGrey,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            var doesAccessExist =
                                await storage.readSecureData("accessToken");
                            if (doesAccessExist != null &&
                                doesAccessExist == "No data found!") {
                            } else {
                              openDrawer();
                            }
                          },
                          child: Ink(
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: ImageIcon(
                                      AssetImage(
                                          "assets/images/navigation.png"),
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xff282829),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Listed",
                          style: homeHeader,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push("/recentlyListed");
                              },
                              child: Text(
                                "View All",
                                style: viewText,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xffD06F0E),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12.sp,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.52,
                      child: properties.when(
                        data: (data) {
                          if (data.isNotEmpty) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length > 5 ? 5 : data.length,
                                itemBuilder: (itemBuilder, index) {
                                  return Row(
                                    children: [
                                      PropertyWidget(
                                          width: width, property: data[index]),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            return Center(
                              child: Text(
                                "No Property Listed yet",
                                style: secondaryText,
                              ),
                            );
                          }
                        },
                        error: (error, _) {
                          return Text("Error fetching data");
                        },
                        loading: () {
                          return SpinKitCubeGrid(
                            size: 20,
                            color: blackGrey,
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Funded",
                          style: homeHeader,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.19,
                      child: recentlyFunded.when(data: (data) {
                        if (data.isNotEmpty) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length < 5 ? data.length : 5,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  0.75) *
                                              0.55,
                                      // height: MediaQuery.of(context).size.height *
                                      //     0.4,
                                      // height: 120.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                          image: data[index].thumbnail != null
                                              ? NetworkImage(
                                                  data[index].thumbnail!)
                                              : AssetImage(
                                                      "assets/images/villa.jpeg")
                                                  as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.sp,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.sp,
                                              horizontal: 10.sp),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF5FAEB)
                                                  .withOpacity(0.8),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(1000),
                                              ),
                                              border: Border.all(
                                                color: Color(0xffCCCCCC),
                                                width: .6,
                                              )),
                                          child: Text(
                                            data[index].type!,
                                            style: GoogleFonts.poppins(
                                                color: Color(0xff5F8729),
                                                fontWeight: FontWeight.w600,
                                                fontSize: text__sm),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75) *
                                              0.405,
                                          child: Text(
                                            data[index].title!,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: text__md),
                                          ),
                                        ),
                                        Text(
                                          data[index].location!.name!,
                                          style: GoogleFonts.poppins(
                                            color: Color(0xff4E4F50),
                                            fontWeight: FontWeight.w400,
                                            fontSize: text__xs,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Fund Raised",
                                          style: GoogleFonts.poppins(
                                            color: Color(0xff6B6B6F),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 6.sp,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ImageIcon(
                                              AssetImage(
                                                "assets/images/naira_grey.png",
                                              ),
                                            ),
                                            Text(
                                              data[index].fundRaised.toString(),
                                              style: GoogleFonts.poppins(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: text__sm,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              "No Property Funded yet",
                              style: secondaryText,
                            ),
                          );
                        }
                      }, error: (error, _) {
                        return Container(
                          child: Center(
                            child: Text(
                              "Unable to fetch data at the moment",
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );
                      }, loading: () {
                        return Container(
                          child: Center(
                            child: SpinKitCubeGrid(
                              size: 20,
                              color: blackGrey,
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PropertyWidget extends StatefulWidget {
  PropertyWidget({
    super.key,
    required this.width,
    required this.property,
  });

  late final double width;
  final Property property;

  @override
  State<PropertyWidget> createState() => _PropertyWidgetState();
}

class _PropertyWidgetState extends State<PropertyWidget> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push("/property/" + widget.property.id! + "/homepage");
      },
      child: Ink(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: widget.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.33,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                              image: widget.property.thumbnail != null
                                  ? NetworkImage(widget.property.thumbnail!)
                                  : AssetImage("assets/images/house.png")
                                      as ImageProvider,
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      right: 20,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.88),
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          onPressed: () async {
                            var response =
                                await saveProperty(widget.property.id!);
                            final data = response["data"];
                            if (response["success"]) {
                              setState(() {
                                favorite = true;
                              });
                            } else if (response["message"] == "Already Saved") {
                              setState(() {
                                favorite = true;
                              });
                            } else {
                              showErrorDialog(context, "Unable to save");
                            }
                            // widget.width = 100;
                          },
                          icon: Icon(
                            color: favorite
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
                      left: 10,
                      top: 20,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          formatDropdownString(widget.property.type!),
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
                  height: 10,
                ),
                ProjectDescText(
                    initial: true,
                    width: widget.width * 0.75,
                    location: widget.property.location?.name ?? "",
                    property: widget.property.title!,
                    fundRaised: widget.property.fundRaised!,
                    targetFund: widget.property.targetFund!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> onBackButtonPressed(BuildContext context) async {
  bool? confirmLogout = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text("Are you sure you want to exit the application?"),
      content: Text("Do you really want to exit?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true for 'Yes' button
          },
          child: const Text(
            "Yes",
            style: TextStyle(
              color: secondaryColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Return false for 'No' button
          },
          child: const Text(
            "No",
            style: TextStyle(
              color: secondaryColor,
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );

  return confirmLogout ?? false; // Handle the case when the dialog is dismissed
}
