import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/features/flipping/models/NewFlippingModel.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_contact.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_details.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_evidence.dart';
import 'package:wealth/presentation/pages/profile.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';

import '../../features/flipping/requests/flipping_requests.dart';
import '../colors.dart';

final newListingModel = StateProvider<NewProperty>((ref) => new NewProperty());

class FlippingPage extends ConsumerStatefulWidget {
  const FlippingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FlippingPage> createState() => _FlippingPageState();
}

// class _FlippingPageState extends ConsumerState<FlippingPage> {
//   TextEditingController propertyTitleController = TextEditingController();
//
//   List<Widget> pages = [
//     PropertyDetails(),
//     PropertyEvidence(),
//     PropertyContact()
//   ];
//
//   int pageIndex = 0;
//
//   DateTime? _lastClicked;
//
//   handleSubmit() async {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(.5),
//       builder: (BuildContext context) {
//         return loaderWidget();
//       },
//     );
//     var listingModel = ref.read(newListingModel.notifier).state;
//     var imageListing = ref.read(imagesProvider.notifier).state;
//     List<File?> imagesList = [
//       imageListing.firstImage,
//       imageListing.secondImage,
//       imageListing.thirdImage,
//       imageListing.fourthImage
//     ];
//
//     if (listingModel.emergencyContact == null ||
//         listingModel.emergencyEmail == null ||
//         // listingModel.thumbnailUrl == null ||
//         listingModel.title == null ||
//         listingModel.type == null ||
//         listingModel.location == null ||
//         listingModel.videoUrl == null ||
//         listingModel.streetLocation == null ||
//         listingModel.propertySize == null ||
//         listingModel.videoUrl!.isEmpty ||
//         listingModel.description!.isEmpty ||
//         listingModel.price == null ||
//         listingModel.price! <= 0 ||
//         imageListing.thirdImage == null ||
//         imageListing.bannerImage == null ||
//         imageListing.firstImage == null) {
//       Navigator.pop(context);
//       showErrorDialog(context, "Please make sure all the fields are filled");
//     } else if (imagesList.isEmpty) {
//       Navigator.pop(context);
//       showErrorDialog(context, "Please try again later");
//     } else {
//       String bannerImageUrl = await imagesToBeHosted(imageListing.bannerImage);
//       List<String> imagesUrlReturned = await imagesHostToUrl(imagesList);
//
//       listingModel.thumbnailUrl = bannerImageUrl;
//       listingModel.images = imagesUrlReturned;
//
//       var response = await createProperty(listingModel);
//       if (response["success"]) {
//         Navigator.pop(context);
//         ref.invalidate(newListingModel);
//         ref.invalidate(imagesProvider);
//         return showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(20),
//               ),
//             ),
//             // title: Text(""),
//             content: RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                 text:
//                     "Your property listing request is not verified yet. Once it verified, you will be contacted by custumer support to verify these details",
//                 style: GoogleFonts.poppins(
//                   color: secondaryTextColor,
//                 ),
//               ),
//             ),
//             actions: [
//               BTN(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   onTap: () {
//                     context.go('/initial_page');
//                   },
//                   text: "Homepage")
//             ],
//           ),
//         );
//       } else {
//         showErrorDialog(context, response["message"]);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (pageIndex > 0 ||
//             DateTime.now().difference(_lastClicked!) > Duration(seconds: 1)) {
//           _lastClicked = DateTime.now();
//           --pageIndex;
//           setState(() {});
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: SafeArea(
//         child: Scaffold(
//           bottomNavigationBar: Container(
//             //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//             //         height: MediaQuery.of(context).size.height * 0.08,
//             color: Colors.transparent,
//             height: (MediaQuery.of(context).size.height * 0.08) + 20,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: BTN(
//               width: MediaQuery.of(context).size.width,
//               text: pageIndex == 2 ? "Submit" : "Continue",
//               onTap: () => {
//                 setState(() {
//                   if (pageIndex == 2) {
//                     // return;
//                     handleSubmit();
//                     return;
//                   }
//                   pageIndex++;
//                   return;
//                 }),
//                 if (pageIndex == 2 || pageIndex > 2) {},
//
//                 // context.push("/forgotVerification")
//               },
//             ),
//           ),
//           backgroundColor: Colors.white,
//           body: Container(
//             padding: EdgeInsets.symmetric(
//               vertical: 5,
//               horizontal: 20,
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Container(
//                           width: 50,
//                           height: 50,
//                           padding:
//                               EdgeInsets.symmetric(vertical: 0, horizontal: 1),
//                           child: Center(
//                             child: Icon(Icons.arrow_back_ios_new, size: 20),
//                           ),
//                           decoration: BoxDecoration(
//                             color: appBarIcon,
//                             border: Border.all(
//                               color: Color(0xffDDC9BB),
//                               width: 2,
//                               style: BorderStyle.solid,
//                             ),
//                             borderRadius: BorderRadius.all(Radius.circular(40)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text(
//                         "List Your Property",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xff333333),
//                           // color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: 5,
//                       width: MediaQuery.of(context).size.width * 0.28,
//                       decoration: BoxDecoration(
//                         color: pageIndex >= 0
//                             ? Color(0xff282829)
//                             : Color(0xffE6E6E7),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 5,
//                       width: MediaQuery.of(context).size.width * 0.28,
//                       decoration: BoxDecoration(
//                         color: pageIndex >= 1
//                             ? Color(0xff282829)
//                             : Color(0xffE6E6E7),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 5,
//                       width: MediaQuery.of(context).size.width * 0.28,
//                       decoration: BoxDecoration(
//                         color: pageIndex >= 2
//                             ? Color(0xff282829)
//                             : Color(0xffE6E6E7),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8.0,
//                       horizontal: 0,
//                     ),
//                     child: SingleChildScrollView(
//                       child: pages[pageIndex],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


class _FlippingPageState extends ConsumerState<FlippingPage> {
  TextEditingController propertyTitleController = TextEditingController();
  late PageController _controller; // PageController to control PageView

  // List<Widget> pages = [
  //   PropertyDetails(),
  //   PropertyEvidence(),
  //   PropertyContact(),
  // ];

  List<Widget> pages = [
    SingleChildScrollView(child: PropertyDetails()),
    SingleChildScrollView(child: PropertyEvidence()),
    SingleChildScrollView(child: PropertyContact()),
  ];


  int pageIndex = 0;

  DateTime? _lastClicked;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: pageIndex); // Initialize PageController
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  handleSubmit() async {
    // Your handleSubmit logic here...
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pageIndex > 0 ||
            DateTime.now().difference(_lastClicked!) > Duration(seconds: 1)) {
          _lastClicked = DateTime.now();
          _controller.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.transparent,
            height: (MediaQuery.of(context).size.height * 0.08) + 20,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: BTN(
              width: MediaQuery.of(context).size.width,
              text: pageIndex == 2 ? "Submit" : "Continue",
              onTap: () {
                if (pageIndex == 2) {
                  handleSubmit();
                } else {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            child: Column(
              children: [
                // Back button and title bar
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "List Your Property",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff333333),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                        color: pageIndex >= 0
                            ? Color(0xff282829)
                            : Color(0xffE6E6E7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                        color: pageIndex >= 1
                            ? Color(0xff282829)
                            : Color(0xffE6E6E7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                        color: pageIndex >= 2
                            ? Color(0xff282829)
                            : Color(0xffE6E6E7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // PageView for sliding between pages
                // PageView for sliding between pages
                Expanded(
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        pageIndex = index;
                      });
                    },
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<bool> _onWillPop() async {
//   return (await showDialog(
//     context: context,
//     builder: (context) => new AlertDialog(),
//   )) ?? false;
// }
