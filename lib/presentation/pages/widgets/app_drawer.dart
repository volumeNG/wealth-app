import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import 'package:wealth/state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors.dart';
import '../../font_sizes.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.775,
      child: Drawer(
        backgroundColor: Colors.white,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: Colors.white,
          height: height,
          // width: width,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Important: Remove any padding from the ListView.
            // padding: EdgeInsets.zero,
            children: [
              InkWell(
                onTap: () {
                  context.pop();
                },
                child: Ink(
                  child: Row(
                    children: [
                      Container(
                        width: 40.sp,
                        height: 40.sp,
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
              Column(
                children: [
                  NavigationIcons(
                      path: "assets/images/person.png",
                      identifier: "Profile",
                      onTap: () {
                        context.push("/profile");
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  NavigationIcons(
                      path: "assets/images/call.png",
                      identifier: "AI Support",
                      onTap: () {
                        context.push("/support");
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  NavigationIcons(
                      path: "assets/images/like.png",
                      identifier: "My Favourite Properties ",
                      onTap: () {
                        context.push("/favourite");
                      }),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // NavigationIcons(
                  //     path: "assets/images/transaction.png",
                  //     identifier: "Transaction History",
                  //     onTap: () {}),
                  SizedBox(
                    height: 15,
                  ),
                  NavigationIcons(
                      path: "assets/images/properties.png",
                      identifier: "My Properties",
                      onTap: () {
                        context.push("/my_properties");
                      }),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // NavigationIcons(
                  //     path: "assets/images/subscription.png",
                  //     identifier: "Subscription",
                  //     onTap: () {}),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // NavigationIcons(
                  //     path: "assets/images/feedback.png",
                  //     identifier: "Feedback",
                  //     onTap: () {}),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              NavigationIcons(
                  path: "assets/images/logout.png",
                  identifier: "Logout",
                  onTap: () async {
                    await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white,
                        elevation: 8,
                        title: Text(
                          "Are you sure you want to exit the application?",
                          style: GoogleFonts.poppins(
                              color: secondaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        content: Text(
                          "Do you really want to exit?",
                          style: GoogleFonts.poppins(
                            color: secondaryTextColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ref.invalidate(profile_Provider);
                              ref.invalidate(userSignIn);
                              ref.invalidate(signUpResponseProvider);
                              // exit(0); // Return true for 'Yes' button
                              context.go("/signIn");
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
                              Navigator.of(context)
                                  .pop(false); // Return false for 'No' button
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
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationIcons extends StatelessWidget {
  const NavigationIcons({
    super.key,
    required this.onTap,
    required this.path,
    required this.identifier,
  });

  final Function() onTap;
  final String path;
  final String identifier;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Center(child: Image.asset(path)),
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
                color: appBarIcon,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          SizedBox(
            width: 5.sp,
          ),
          Text(
            identifier,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Color(0xff333333),
              // fontSize: text__md,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
