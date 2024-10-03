import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_url_validator/video_url_validator.dart';
import 'package:wealth/presentation/pages/components/property_listing/property_details.dart';
import '../../flipping_page.dart';
import '../../widgets/flippingLabelText.dart';

class ImageFiles {
  File? bannerImage;
  File? firstImage;
  File? secondImage;
  File? thirdImage;
  File? fourthImage;
}

final imagesProvider = StateProvider<ImageFiles>((ref) => ImageFiles());

class PropertyEvidence extends ConsumerStatefulWidget {
  const PropertyEvidence({Key? key}) : super(key: key);

  @override
  ConsumerState<PropertyEvidence> createState() => _PropertyEvidenceState();
}

class _PropertyEvidenceState extends ConsumerState<PropertyEvidence> {
  File bannerImage = new File("");
  late File projectVideo;
  File _image = new File("");
  File _secondImage = new File("");
  File _thirdImage = new File("");
  File _fourthImage = new File("");

  TextEditingController propertyVideoLink = TextEditingController();

  var validator = VideoURLValidator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    final imageState = ref.read(imagesProvider.notifier).state;
    propertyVideoLink.text =
        ref.read(newListingModel.notifier).state.videoUrl ?? "";
    bannerImage = imageState.bannerImage ?? File("");
    _image = imageState.firstImage ?? File("");
    _secondImage = imageState.secondImage ?? File("");
    _thirdImage = imageState.thirdImage ?? File("");
    _fourthImage = imageState.fourthImage ?? File("");
  }

  Future<void> pickBannerImage() async {
    final imageState = ref.read(imagesProvider.notifier).state;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        bannerImage = File(result.files.single.path!);
      });
      imageState.bannerImage = bannerImage;
    } else {
      print("No file selected");
    }
  }

  Future<void> pickProjectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'mkv', 'avi'],
    );
    if (result != null) {
      projectVideo = File(result.files.single.path!);
    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    void _pickFirstImage(int num) async {
      final imageState = ref.read(imagesProvider.notifier).state;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      // if no file is picked
      if (result == null) return;
      File pickedImageFile = File(result.files.single.path!);
      switch (num) {
        case 0:
          imageState.firstImage = pickedImageFile;
          setState(() {
            _image = pickedImageFile;
          });
          break;
        case 1:
          imageState.secondImage = pickedImageFile;
          setState(() {
            _secondImage = pickedImageFile;
          });
          break;
        case 2:
          imageState.thirdImage = pickedImageFile;
          setState(() {
            _thirdImage = pickedImageFile;
          });
          break;
        case 3:
          imageState.fourthImage = pickedImageFile;
          setState(() {
            _fourthImage = pickedImageFile;
          });
          break;
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText(text: "Banner Image"),
          GestureDetector(
            onTap: () {
              pickBannerImage();
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: bannerImage.path.isNotEmpty
                        ? FileImage(bannerImage)
                        : AssetImage("assets/images/upload_banner.png")
                            as ImageProvider,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // bannerImage.path.isNotEmpty
          //     ? Column(
          //         children: [
          //           Container(
          //             width: double.infinity,
          //             height: 5,
          //             decoration: BoxDecoration(
          //               color: Colors.green,
          //               borderRadius: BorderRadius.all(Radius.circular(20)),
          //             ),
          //           ),
          //           Text(
          //             bannerImage.path,
          //           )
          //         ],
          //       )
          //     : SizedBox.shrink(),
          // GestureDetector(
          //   onTap: () {
          //     pickProjectVideo();
          //   },
          //   child: Container(
          //     height: 200,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(20)),
          //       image: DecorationImage(
          //           image: AssetImage("assets/images/upload_video.png"),
          //           fit: BoxFit.cover),
          //     ),
          //   ),
          // ),
          InputLabelField(
              onChanged: (value) {
                if (validator.validateYouTubeVideoURL(url: value.toString()) ==
                    true) {
                  ref.read(newListingModel.notifier).state.videoUrl =
                      propertyVideoLink.text;
                }
              },
              controller: propertyVideoLink,
              label: "Property Video YouTube Link"),
          SizedBox(
            height: 20,
          ),
          labelText(text: "Other Images"),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _pickFirstImage(0);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 100.w,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                          image: _image.path.isEmpty
                              ? AssetImage("assets/images/pick_image.png")
                              : FileImage(_image) as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _pickFirstImage(1);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 100.w,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                          image: _secondImage.path.isEmpty
                              ? AssetImage("assets/images/pick_image.png")
                              : FileImage(_secondImage)
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _pickFirstImage(2);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 100.w,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                          image: _thirdImage.path.isEmpty
                              ? AssetImage("assets/images/pick_image.png")
                              : FileImage(_thirdImage) as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _pickFirstImage(3);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 100.w,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                          image: _fourthImage.path.isEmpty
                              ? AssetImage("assets/images/pick_image.png")
                              : FileImage(_fourthImage)
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
