import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/flipping_page.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import '../../../../utilities.dart';
import '../../../colors.dart';
import '../../widgets/flippingLabelText.dart';

class PropertyDetails extends ConsumerStatefulWidget {
  const PropertyDetails({Key? key}) : super(key: key);

  @override
  ConsumerState<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends ConsumerState<PropertyDetails> {
  String propertyValue = "land";
  String locationValue = "Abuja,Nigeria";
  TextEditingController propertyTitleController = TextEditingController();
  TextEditingController streetLocationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController propertySizeController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    final newState = ref.read(newListingModel.notifier).state;
    propertyTitleController.text = newState.title ?? "";
    streetLocationController.text = newState.streetLocation ?? "";
    priceController.text = newState.price.toString() ?? "0";
    roomController.text = newState.rooms.toString() ?? "0";
    propertySizeController.text = newState.propertySize ?? "";
    descController.text = newState.description ?? "";
    newState.type = propertyValue;
    propertyValue = newState.type ?? "land";
    newState.location = locationValue;
    locationValue = newState.location ?? "Abuja,Nigeria";
  }

  List<String> propertyType = [
    "land",
    "semiDetachedHouse",
    "detachedHouse",
    "finished",
    "unFinished"
  ];
  List<String> locationList = [
    "Abuja,Nigeria",
    "Lagos,Nigeria",
    "Ogun,Nigeria",
    "Osun,Nigeria",
  ];

  @override
  Widget build(BuildContext context) {
    final newState = ref.read(newListingModel.notifier).state;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputLabelField(
                controller: propertyTitleController,
                onChanged: (value) {
                  newState.title = propertyTitleController.text;
                },
                label: "Property Title"),
            SizedBox(
              height: 20,
            ),
            labelText(text: "Property Type"),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xffDDDDDD),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      icon: Icon(Icons.keyboard_arrow_down_sharp),
                      isExpanded: false,
                      isDense: true,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff444446),
                      ),
                      dropdownColor: Color(0xffccc5c5),
                      elevation: 0,
                      value: propertyValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          propertyValue = newValue!;
                          newState.type = propertyValue;
                        });
                      },
                      items: propertyType.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
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
            labelText(text: "Property Location"),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xffDDDDDD),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      icon: Icon(Icons.keyboard_arrow_down_sharp),
                      isExpanded: false,
                      isDense: true,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff444446),
                      ),
                      dropdownColor: Color(0xffccc5c5),
                      elevation: 0,
                      value: locationValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          locationValue = newValue!;
                          newState.location = locationValue;
                        });
                      },
                      items: locationList.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
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
            InputLabelField(
                onChanged: (value) {
                  newState.streetLocation = streetLocationController.text;
                },
                controller: streetLocationController,
                label: "Street Location"),
            SizedBox(
              height: 20,
            ),
            InputLabelField(
              controller: priceController,
              onChanged: (value) {
                newState.price = double.parse(priceController.text);
              },
              label: "Price",
              number: true,
              prefixIcon: ImageIcon(
                AssetImage("assets/images/naira_grey.png"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How Many Rooms?",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Color(0xff6B6B6F),
                        ),
                      ),
                      Text(
                        "(Optional)",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          color: Color(0xff6B6B6F),
                        ),
                      ),
                      InputLabelField(
                          onChanged: (value) {
                            newState.rooms = int.parse(roomController.text);
                          },
                          controller: roomController,
                          number: true,
                          label: ""),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelText(text: "Property Size"),
                      InputLabelField(
                        controller: propertySizeController,
                        onChanged: (value) {
                          newState.propertySize = propertySizeController.text;
                        },
                        label: "",
                        suffixIcon: ImageIcon(
                          AssetImage("assets/images/property_size.png"),
                          size: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            InputLabelTextArea(
                controller: descController,
                onChanged: (value) {
                  newState.description = descController.text;
                },
                label: "Description/Purpose")
          ],
        ),
      ),
    );
  }
}

class InputLabelField extends ConsumerWidget {
  const InputLabelField({
    super.key,
    // required this.width,
    required this.controller,
    required this.label,
    this.number = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  // final double width;
  final TextEditingController controller;
  final String label;
  final bool number;
  final ImageIcon? prefixIcon;
  final ImageIcon? suffixIcon;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isNotEmpty
            ? Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xff6B6B6F),
                ),
              )
            : SizedBox.shrink(),
        label.isNotEmpty
            ? SizedBox(
                height: 10,
              )
            : SizedBox.shrink(),
        Container(
          height: 50,
          child: TextFormField(
            controller: controller,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              // color: Color(0xffE3E7E7),
              color: Color(0xff222222),
              // fontSize: width * 0.04,
            ),
            textAlign: TextAlign.start,
            keyboardType: number ? TextInputType.number : TextInputType.text,
            onChanged: onChanged,
            cursorColor: softBlack,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null ? prefixIcon : null,
              suffixIcon: suffixIcon != null ? suffixIcon : null,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  // color: Color(0xffE3E7E7),
                  color: Color(0xffDDDDDD),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: softBlack,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class InputLabelTextArea extends StatelessWidget {
  const InputLabelTextArea({
    super.key,
    // required this.width,
    required this.controller,
    required this.label,
    this.onChanged,
    this.number = false,
  });

  // final double width;
  final TextEditingController controller;
  final String label;
  final bool number;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isNotEmpty
            ? Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xff6B6B6F),
                ),
              )
            : SizedBox.shrink(),
        label.isNotEmpty
            ? SizedBox(
                height: 10,
              )
            : SizedBox.shrink(),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                // color: Color(0xffE3E7E7),
                color: Color(0xffDDDDDD),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
          height: 150,
          child: TextField(
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: controller,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Color(0xff222222),
              // fontSize: width * 0.04,
            ),
            textAlign: TextAlign.start,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            minLines: 1,
            maxLines: 5,
            onChanged: onChanged,
            cursorColor: softBlack,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              hintText: "Write here details!",
              hintStyle: GoogleFonts.poppins(
                fontSize: 14.r,
                fontWeight: FontWeight.w400,
                color: Color(0xffB1B1B4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  // color: Color(0xffE3E7E7),
                  // color: Color(0xffDDDDDD),
                  color: Colors.transparent,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  // color: Color(0xffE3E7E7),
                  // color: Color(0xffDDDDDD),
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  // color: softBlack,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }
}
