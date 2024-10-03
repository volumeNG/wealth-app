import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wealth/features/profile/requests/requests.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/widgets/app_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';

import '../../features/flipping/requests/flipping_requests.dart';
import '../colors.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  File _image = new File("");

  void _changeProfileImage() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'jpeg', 'png'],
    // );
    //
    // // if no file is picked
    // if (result == null) return;
    // File pickedImageFile = File(result.files.single.path!);
    // setState(() {
    //   _image = pickedImageFile;
    // });
    // showDialog(
    //   context: context,
    //   barrierColor: Colors.black.withOpacity(.5),
    //   // Make the barrier transparent
    //   builder: (BuildContext context) {
    //     return loaderWidget();
    //   },
    // );

    final ImagePicker _picker = ImagePicker();

    // Allow the user to pick an image from the gallery
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // Set to ImageSource.camera to allow camera input
      imageQuality: 80,            // Compress image quality (optional)
      maxWidth: 800,               // Resize to a maximum width (optional)
      maxHeight: 800,              // Resize to a maximum height (optional)
    );

    // If no image is selected
    if (image == null) return;

    File pickedImageFile = File(image.path);

    setState(() {
      _image = pickedImageFile;
    });

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext context) {
        return loaderWidget();  // Custom loader widget
      },
    );

    String profileImg = await imagesToBeHosted(_image);
    var response;
    if (profileImg != null) {
      response = await submitProfileImageUpdate(
          ref.watch(profile_Provider.notifier).state.id!, profileImg);
    }
    if (response['success']) {
      // Future.delayed(Duration(seconds: 5), () => {Navigator.pop(context)});
      ref.read(refreshHomePageProvider)(context);
      Navigator.pop(context);
      setState(() {});
      ref.read(refreshHomePageProvider)(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? profileImage =
        ref.watch(profile_Provider.notifier).state?.profileImg;

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: secondaryHeader,
          ),
          leading: InkWell(
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
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.r),
                          ),
                          image: DecorationImage(
                            image: profileImage != null
                                ? NetworkImage(profileImage)
                                : AssetImage(
                                        "assets/images/profile_picture.png")
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),

                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        right: -40,
                        child: Container(
                            height: 100,
                            width: 100,
                            child: GestureDetector(
                              onTap: () {
                                _changeProfileImage();
                              },
                              child: Image.asset("assets/images/edit.png"),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 22.sp,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref
                                  .read(profile_Provider.notifier)
                                  .state
                                  .name
                                  .toString() ??
                              "",
                          style: homeHeader,
                        ),
                        Text(
                          ref
                                  .read(profile_Provider.notifier)
                                  .state
                                  .email
                                  .toString() ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8A9DA6),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              NavigationIcons(
                  path: "assets/images/person.png",
                  identifier: "Personal Information",
                  onTap: () {
                    context.push("/personal_information");
                  }),
              SizedBox(
                height: 30,
              ),
              // NavigationIcons(
              //     path: "assets/images/settings.png",
              //     identifier: "Settings",
              //     onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class loaderWidget extends StatelessWidget {
  const loaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Center(
        child: Material(
          color: Colors.transparent, // Make the material content transparent
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: linkTextOrange,
                backgroundColor: Colors.white,
                strokeWidth: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildLoaderDialog(BuildContext context) {
  return Center(
    child: Material(
      color: Colors.transparent, // Make the material content transparent
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: linkTextOrange,
            backgroundColor: Colors.white,
            strokeWidth: 5,
          ),
          // Add a button or tap gesture to trigger closing (optional)
          TextButton(
            onPressed: () => Navigator.pop(context),
            // Close dialog on button press
            child: Text('Close'),
          ),
        ],
      ),
    ),
  );
}
