import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/features/profile/requests/requests.dart';
import 'package:wealth/presentation/pages/profile.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/button_1.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import '../colors.dart';
import 'homepage.dart';

enum EUserGender { male, female }

class PersonalInformation extends ConsumerStatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  ConsumerState<PersonalInformation> createState() =>
      _PersonalInformationState();
}

final genderProvider = StateProvider<EUserGender?>((ref) => EUserGender.male);

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  bool readOnly = true;
  TextEditingController dateInput = TextEditingController();
  TextEditingController fullName = TextEditingController();

  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController locationController = TextEditingController();
  EUserGender gender = EUserGender.male;
  String dateOfBirthIso = "";
  @override
  void initState() {
    super.initState();
    dateInput.text = ""; // set the initial value of text field
    initializeControllers();
  }

  void initializeControllers() {
    final profile = ref.read(profile_Provider.notifier).state;
    emailAddress.text = profile.email ?? "";
    fullName.text = profile.name?.toString() ?? '';
    final dateOfBirth = profile.dateOfBirth;
    dynamic genderValue = profile.gender;

    if (genderValue == null || genderValue.isEmpty) {
      genderValue = "male";
    } else {
      try {
        if (genderValue == "male") {
          gender = EUserGender.male;
          Future(() {
            ref.read(genderProvider.notifier).state = EUserGender.male;
          });
        } else if (genderValue == "female") {
          gender = EUserGender.female;
          Future(() {
            ref.read(genderProvider.notifier).state = EUserGender.female;
          });
        }
      } catch (ex) {
        print(ex);
      }
    }

    if (dateOfBirth == null || dateOfBirth.isEmpty) {
      dateInput.text = "";
    } else {
      try {
        dateInput.text = DateFormat.yMMMd().format(DateTime.parse(dateOfBirth));
        dateOfBirthIso = dateOfBirth;
      } catch (e) {
        // Handle the error if parsing fails
        dateInput.text = "";
        // print("Error parsing dateOfBirth: $e");
      }
    }
    locationController.text = profile.location?.toString() ?? '';
  }

  handleSubmit() async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      // Make the barrier transparent
      builder: (BuildContext context) {
        return loaderWidget();
      },
    );
    var response = await submitProfileUpdate(
        ref.watch(profile_Provider.notifier).state.id!,
        fullName.text,
        ref.watch(genderProvider.notifier).state!,
        locationController.text,
        dateOfBirthIso);
    setState(() {
      readOnly = !readOnly;
    });
    Navigator.pop(context);
    setState(() {});
    if (response["statusCode"] == 200) {
      ref.read(refreshHomePageProvider)(context);
      context.go("/initial_page");
    } else {
      showErrorDialog(context, "Unable to update details");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    locationController.text = "";
    dateOfBirthIso = "";
    fullName.text = "";
    locationController.text = "";
    // ref.invalidate(genderProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          bottomNavigationBar: readOnly
              ? SizedBox.shrink()
              : Container(
                  height: MediaQuery.of(context).size.height * 0.085,
                  child: BTN(
                    onTap: handleSubmit,
                    width: MediaQuery.of(context).size.width,
                    text: "Save Changes",
                  ),
                ),
          body: Column(
            children: [
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
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Personal Information", style: secondaryHeader),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                readOnly = !readOnly;
                              });
                            },
                            icon: ImageIcon(
                              AssetImage("assets/images/profile_edit.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputFieldProfile(
                                controller: fullName,
                                readOnly: readOnly,
                                labelText: "FullName",
                                icondata: Icons.person_outline_rounded),
                            SizedBox(
                              height: 20,
                            ),
                            InputFieldProfile(
                                controller: emailAddress,
                                readOnly: true,
                                labelText: "Email",
                                icondata: Icons.email_outlined),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Date of Birth",
                              style: GoogleFonts.poppins(
                                  color: readOnly
                                      ? Color(0xff6B6B6F)
                                      : Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: readOnly ? 12.sp : 14.sp),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: readOnly
                                  ? () {}
                                  : () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now(),
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              scaffoldBackgroundColor:
                                                  Colors.red,
                                              colorScheme: ColorScheme.light(
                                                primary: Color(0xff37474F),
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                    // primary: Color(0xff6B6B6F),
                                                    backgroundColor: Color(0xff6B6B6F),
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (pickedDate != null) {
                                        print(
                                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                        String formattedDate =
                                            // DateFormat('yyyy-MM-dd').format(pickedDate);
                                            DateFormat.yMMMd()
                                                .format(pickedDate);
                                        setState(() {
                                          dateOfBirthIso = DateFormat(
                                                  "yyyy-MM-dd'T'HH:mm:ss'Z'")
                                              .format(pickedDate);

                                          // pickedDate.toIso8601String();
                                          dateInput.text =
                                              formattedDate; //set output date to TextField value.
                                        });
                                      } else {}
                                    },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xff9e9d9d),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 40,
                                      color: readOnly
                                          ? Color(0xff9b9b9b)
                                          : Color(0xff200E32),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      dateInput.text.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        color: readOnly
                                            ? Color(0xff9b9b9b)
                                            : secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InputFieldProfile(
                                controller: locationController,
                                readOnly: readOnly,
                                labelText: "Location",
                                icondata: Icons.location_on_outlined),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Gender",
                              style: GoogleFonts.poppins(
                                  color: readOnly
                                      ? Color(0xff6B6B6F)
                                      : Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: readOnly ? 12.sp : 14.sp),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // readOnly
                            //     ? Text(gender.toString()):
                            GenderSelector(character: gender),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The input field widget for the personal information's
class InputFieldProfile extends StatelessWidget {
  const InputFieldProfile({
    super.key,
    required this.controller,
    required this.readOnly,
    required this.labelText,
    required this.icondata,
  });

  final TextEditingController controller;
  final bool readOnly;
  final String labelText;
  final IconData icondata;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(
              color: readOnly ? Color(0xff6B6B6F) : Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: readOnly ? 12.sp : 14.sp),
        ),
        SizedBox(
          height: 10,
        ),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: Colors.transparent,
              cursorColor: secondaryTextColor,
            ),
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              color: readOnly ? Color(0xff9b9b9b) : secondaryColor,
            ),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.sp, horizontal: 48.sp),
              prefixIcon: Icon(
                icondata,
                size: 32.sp,
                color: readOnly ? Color(0xff9b9b9b) : Color(0xff200E32),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xffF5F5F5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xff200E32),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///This deals with the gender changes
class GenderSelector extends ConsumerStatefulWidget {
  GenderSelector({Key? key, required this.character}) : super(key: key);
  EUserGender character;

  @override
  ConsumerState<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends ConsumerState<GenderSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff9e9d9d),
                  width: 1,
                ),
                // color:
                //     widget.character == Gender.male ? Colors.red : Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(15.r))),
            child: ListTile(
              title: Text(
                'Male',
                style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff091E42)),
              ),
              trailing: Radio<EUserGender>(
                value: EUserGender.male,
                focusColor: Color(0xffD06F0E),
                activeColor: Color(0xffD06F0E),
                groupValue: widget.character,
                onChanged: (EUserGender? value) {
                  ref.read(genderProvider.notifier).state = value;
                  setState(() {
                    widget.character = value!;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff9e9d9d),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.r))),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              title: Text(
                'Female',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff091E42),
                ),
              ),
              trailing: Radio<EUserGender>(
                value: EUserGender.female,
                groupValue: widget.character,
                focusColor: Color(0xffD06F0E),
                activeColor: Color(0xffD06F0E),
                onChanged: (EUserGender? value) {
                  ref.read(genderProvider.notifier).state = value;
                  setState(() {
                    widget.character = value!;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
