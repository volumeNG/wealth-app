import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_details.dart';

import '../../flipping_page.dart';
import '../../widgets/flippingLabelText.dart';

class PropertyContact extends ConsumerStatefulWidget {
  const PropertyContact({Key? key}) : super(key: key);

  @override
  ConsumerState<PropertyContact> createState() => _PropertyContactState();
}

class _PropertyContactState extends ConsumerState<PropertyContact> {
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File _image = new File("");
  File _secondImage = new File("");
  File _thirdImage = new File("");
  File _fourthImage = new File("");

  void _pickFirstImage(int num) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    // if no file is picked
    if (result == null) return;
    File pickedImageFile = File(result.files.single.path!);
    switch (num) {
      case 0:
        setState(() {
          _image = pickedImageFile;
        });
        break;
      case 1:
        setState(() {
          _secondImage = pickedImageFile;
        });
        break;
      case 2:
        setState(() {
          _thirdImage = pickedImageFile;
        });
        break;
      case 3:
        setState(() {
          _fourthImage = pickedImageFile;
        });
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    final newModel = ref.read(newListingModel.notifier).state;
    contactController.text = newModel.emergencyContact ?? "";
    emailController.text = newModel.emergencyEmail ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // labelText(text: "Other Images"),
          // Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         InkWell(
          //           onTap: () {
          //             _pickFirstImage(0);
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width * 0.42,
          //             height: 100.w,
          //             decoration: BoxDecoration(
          //               // color: Colors.red,
          //               image: DecorationImage(
          //                 image: _image.path.isEmpty
          //                     ? AssetImage("assets/images/pick_image.png")
          //                     : FileImage(_image) as ImageProvider<Object>,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //         ),
          //         InkWell(
          //           onTap: () {
          //             _pickFirstImage(1);
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width * 0.42,
          //             height: 100.w,
          //             decoration: BoxDecoration(
          //               // color: Colors.red,
          //               image: DecorationImage(
          //                 image: _secondImage.path.isEmpty
          //                     ? AssetImage("assets/images/pick_image.png")
          //                     : FileImage(_secondImage)
          //                         as ImageProvider<Object>,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //     SizedBox(
          //       height: 20,
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         InkWell(
          //           onTap: () {
          //             _pickFirstImage(2);
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width * 0.42,
          //             height: 100.w,
          //             decoration: BoxDecoration(
          //               // color: Colors.red,
          //               image: DecorationImage(
          //                 image: _thirdImage.path.isEmpty
          //                     ? AssetImage("assets/images/pick_image.png")
          //                     : FileImage(_thirdImage) as ImageProvider<Object>,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //         ),
          //         InkWell(
          //           onTap: () {
          //             _pickFirstImage(3);
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width * 0.42,
          //             height: 100.w,
          //             decoration: BoxDecoration(
          //               // color: Colors.red,
          //               image: DecorationImage(
          //                 image: _fourthImage.path.isEmpty
          //                     ? AssetImage("assets/images/pick_image.png")
          //                     : FileImage(_fourthImage)
          //                         as ImageProvider<Object>,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          InputLabelField(
            controller: contactController,
            label: "Emergency Contact",
            onChanged: (value) {
              ref.read(newListingModel.notifier).state.emergencyContact = value;
            },
            number: true,
          ),
          SizedBox(
            height: 20,
          ),
          InputLabelField(
            controller: emailController,
            label: "Emergency email",
            onChanged: (value) {
              final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (emailValid) {
                ref.read(newListingModel.notifier).state.emergencyEmail = value;
              }
            },
          ),
        ],
      ),
    );
  }
}
