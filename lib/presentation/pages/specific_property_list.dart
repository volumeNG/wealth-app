import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuple/tuple.dart';
import 'package:wealth/features/crowd_funding/models/Property.dart';
import 'package:wealth/features/current_locations/requests/current_locations_requests.dart';
import 'package:wealth/presentation/pages/flipping.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';
import 'components/specific_property.dart';
import 'homepage.dart';

class PropertyInfo extends ConsumerStatefulWidget {
  const PropertyInfo({Key? key, required this.id, required this.name})
      : super(key: key);

  final String id;
  final String name;

  @override
  ConsumerState<PropertyInfo> createState() => _PropertyInfoState();
}

class _PropertyInfoState extends ConsumerState<PropertyInfo> {
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<Property> specificPropertyList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (!_isLoadingMore && (ref.watch(totalPageNumber) > _currentPage * 5)) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage += 1; // Increment the page number
      // Trigger the fetch for the next page
      await ref
          .refresh(specificLocationProperties(Tuple2(widget.id, _currentPage)));
      setState(() {
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        // limitReached = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    AsyncValue<List<Property>> propertyList =
        ref.watch(specificLocationProperties(Tuple2(widget.id, _currentPage)));
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff333333),
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ],
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: propertyList.when(data: (data) {
            if (data.isEmpty) {
              return Center(child: Text("No property found"));
            } else {
              if (specificPropertyList.length <
                  ref.watch(totalPageNumber.notifier).state) {
                for (var item in data) {
                  if (!specificPropertyList.contains(item)) {
                    specificPropertyList.add(item);
                  }
                }
              }
              return ListView.builder(
                  itemCount: specificPropertyList.length,
                  itemBuilder: (itemBuilder, index) {
                    return Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: propertyListing(
                          onTap: () {
                            // ref.read(payment_provider.notifier).state.type = "current";
                            // ref.read(payment_provider.notifier).state.id = widget.id;
                            context.push(
                                "/property/" + data[index].id! + "/current");
                          },
                          width: width,
                          id: specificPropertyList[index].id!,
                          saveType: "current",
                          propertyName: specificPropertyList[index].title!,
                          propertyType: specificPropertyList[index].type!,
                          location: specificPropertyList[index].location!.name!,
                          propertyPrice: specificPropertyList[index].price,
                          thumbnail: specificPropertyList[index].thumbnail!,
                          // propertySize: int.parse(data[index].size!),
                          propertySize: specificPropertyList[index].size!.toString(),
                          roomNumber: specificPropertyList[index].rooms != null
                              ? specificPropertyList[index].rooms.toString()
                              : "0"),
                    );
                  });
            }
          }, error: (error, _) {
            return Center(
              child: Text("Unable to fetch data at this point"),
            );
          }, loading: () {
            return Container(
              child: Center(
                child: SpinKitCubeGrid(
                  size: 20,
                  color: secondaryColor,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
