import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/components/my_properties/funded_or_bought.dart';
import '../colors.dart';
import 'components/my_properties/listed_property.dart';

class PropertiesPage extends ConsumerStatefulWidget {
  const PropertiesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends ConsumerState<PropertiesPage> {
  final PageController _controller = PageController(initialPage: 0);
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20,left: 20,right: 20),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
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
                          Text(
                            "My Properties",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff333333),
                              // color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Listed",
                        style: GoogleFonts.poppins(
                          fontWeight: pageIndex == 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 14.sp,
                          color: pageIndex == 0
                              ? Color(0xff282829)
                              : Color(0xff6B6B6F),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.43,
                        decoration: BoxDecoration(
                          color: pageIndex == 0
                              ? Color(0xff282829)
                              : Color(0xffE6E6E7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Bought/Funded",
                        style: GoogleFonts.poppins(
                          fontWeight: pageIndex == 1
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: 14.sp,
                          color: pageIndex == 1
                              ? Color(0xff282829)
                              : Color(0xff6B6B6F),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.43,
                        decoration: BoxDecoration(
                          color: pageIndex == 1
                              ? Color(0xff282829)
                              : Color(0xffE6E6E7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  controller: _controller,
                  children: const <Widget>[
                    ListedProperty(),
                    AttainedProperty(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
