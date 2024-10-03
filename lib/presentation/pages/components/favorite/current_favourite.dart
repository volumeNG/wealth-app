import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/features/favourite/models/current_location_favorite.dart';
import 'package:wealth/features/favourite/requests/favourite_requests.dart';
import '../../../colors.dart';
import '../specific_property.dart';

class CurrentLocationFavourite extends ConsumerStatefulWidget {
  const CurrentLocationFavourite({Key? key}) : super(key: key);

  @override
  ConsumerState<CurrentLocationFavourite> createState() =>
      _CurrentLocationFavouriteState();
}

class _CurrentLocationFavouriteState
    extends ConsumerState<CurrentLocationFavourite> {
  @override
  Widget build(BuildContext context) {
    // final AsyncValue<List<CrowdFundFavorite>> propertyFavList = ref.watch(
    //     getCrowdFundFavourites);
    final AsyncValue<List<CurrentFavourite>> currentFavorites =
        ref.watch(getCurrentLocationFavorites);
    return Scaffold(
      body: currentFavorites.when(
        data: (data) {
          if (data.isEmpty) {
            return noListing();
          } else {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      propertyListing(
                        onTap: () {
                          context.push("/property/" +
                              data[index].property!.id! +
                              "/current");
                        },
                        width: MediaQuery.of(context).size.width,
                        propertyName: data[index].property?.title! ?? "",
                        location: data[index].property?.streetLocation! ?? "",
                        propertySize:
                            data[index].property?.size.toString() ?? "",
                        propertyType: data[index].property?.type!,
                        roomNumber:
                            data[index].property!.rooms.toString() ?? "",
                        propertyPrice: data[index].property?.price!,
                        favourite: true,
                        thumbnail: data[index].property!.thumbnail!,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                });
          }
        },
        error: (error, _) {
          return Text("Unable to fetch at the moment");
        },
        loading: () {
          return Center(
            child: SpinKitCubeGrid(
              color: blackGrey,
              size: 20,
            ),
          );
        },
      ),
    );
  }
}

class noListing extends StatelessWidget {
  const noListing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
                color: Color(0xff4B4B4E).withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(100.r))),
            child: Center(
              child: Text(
                "0",
                style: GoogleFonts.poppins(
                    wordSpacing: 0,
                    color: Color(0xff4B4B4E),
                    fontWeight: FontWeight.w600,
                    fontSize: 72.sp),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "You have no liked property",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
