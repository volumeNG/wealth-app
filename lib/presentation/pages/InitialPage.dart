import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:wealth/presentation/pages/chat.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_contact.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_details.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_evidence.dart';
import 'package:wealth/presentation/pages/current_locations.dart';
import 'package:wealth/presentation/pages/flipping.dart';
import 'package:wealth/presentation/pages/flipping_page.dart';
import 'package:wealth/presentation/pages/promotions_page.dart';
import 'package:wealth/presentation/pages/support.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'components/bottom_navigation.dart';
import 'homepage.dart';

class InitialPage extends ConsumerStatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends ConsumerState<InitialPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(refreshHomePageProvider)(context);
  }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   print("BACK BUTTONfsafdsafds!"); // Do some stuff.
  //   if (info.ifRouteChanged(context)) return false;
  //   return true;
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   BackButtonInterceptor.add(myInterceptor);
  // }
  //
  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Handle the back button press here
          return onBackButtonPressed(context);
        },
        child: BottomNavigationLayout(
          pages: [
            // Define your pages here
            HomePage(),
            CurrentLocation(),
            Flipping(),
            // FlippingPage(),
            Promotions(),
            Chat(),
          ],
        ));
  }

  // _onBackButtonPressed(BuildContext context) async {
  Future<bool> onBackButtonPressed(BuildContext context) async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Are you sure you want to exit the application?"),
        content: Text("Do you really want to exit?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              exit(0);// Return true for 'Yes' button
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

    return confirmLogout ??
        false; // Handle the case when the dialog is dismissed
  }
}
