import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealth/presentation/pages/onboarding_components/onboarding_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FOnboardingPage extends StatefulWidget {
  const FOnboardingPage({Key? key}) : super(key: key);

  @override
  State<FOnboardingPage> createState() => _FOnboardingPageState();
}

class _FOnboardingPageState extends State<FOnboardingPage> {
  late Material materialButton;
  late int index;
  String btnText = "Skip";

  void _loadFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myText = prefs.getString('userEmail');
    if (myText != null ) {
      context.go("/signIn");
    } else {
      context.go("/initial_page");
    }
  }

  void _setBtnText() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myText = prefs.getString('userEmail');
    if (myText != null ) {
      setState(() {
        btnText = "Sign In";
      });
    } else {
      setState(() {
        btnText = "Enter";
      });
    }
  }


  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
    _setBtnText();
  }

  final listPagesViewModel = [
    PageModel(
      widget: OnboardingPage(
        color: Color(0xffF2F5EB),
        assetPath: "bg_1",
        widget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Invest your money with ",
            children: [
              TextSpan(text: "us", style: TextStyle(color: Color(0xffD06F0E))),
              TextSpan(
                text: ", creating generational wealth.",
              ),
            ],
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 28.sp),
          ),
        ),
      ),
    ),
    PageModel(
      widget: OnboardingPage(
        color: Color(0xffFFFF4F0),
        assetPath: "bg_2",
        widget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "",
            children: [
              TextSpan(
                  text: "Join Now, ",
                  style: TextStyle(color: Color(0xffD06F0E))),
              TextSpan(
                text: "the future is promising",
              ),
            ],
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 28.sp),
          ),
        ),
      ),
    ),
    PageModel(
      widget: OnboardingPage(
        color: Color(0xfffFFFCF5),
        assetPath: "bg_3",
        widget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Promiseland wealth app, ",
            children: [
              TextSpan(
                  text: "creating ",
                  style: TextStyle(color: Color(0xffD06F0E))),
              TextSpan(
                text: "generational wealth for all",
              ),
            ],
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 28.sp),
          ),
        ),
      ),
    ),
  ];

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = listPagesViewModel.length - 1;
            setIndex(listPagesViewModel.length - 1);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 24.sp),
          child: Text(
            'Skip',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          // context.go("/signIn");
          _loadFromPreferences();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 24.sp),
          decoration: BoxDecoration(
              color: Color(0xff444446),
              borderRadius: BorderRadius.all(Radius.circular(50.sp)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff444446).withOpacity(0.5),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                )
              ]),
          child: Text(
            btnText,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        pages: listPagesViewModel,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(
                width: 0.0,
                color: Colors.black54,
              ),
            ),
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      shouldPaint: true,
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                          indicatorDesign: IndicatorDesign.polygon(
                            polygonDesign: PolygonDesign(
                              polygon: DesignType.polygon_circle,
                              polygonSpacer: 18.sp,
                            ),
                          ),
                          // activeIndicator:
                          //     ActiveIndicator(color: Colors.black),New line
                          activeIndicator: ActiveIndicator(color: Colors.black),
                          closedIndicator:
                              ClosedIndicator(color: Colors.white)),
                    ),
                    index == pagesLength - 1
                        ? _signupButton
                        : _skipButton(setIndex: setIndex)
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
