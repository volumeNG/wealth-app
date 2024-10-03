import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/features/favourite/requests/favourite_requests.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/features/flipping/models/FlippingModel.dart';

import '../../../../features/favourite/models/crowdfund_favorite.dart';
import '../../../../features/flipping/models/FavouriteFlippingModel.dart';
import '../../../colors.dart';
import '../specific_property.dart';

class FlippingFavorite extends ConsumerStatefulWidget {
  const FlippingFavorite({Key? key}) : super(key: key);

  @override
  ConsumerState<FlippingFavorite> createState() => _FlippingFavoriteState();
}

class _FlippingFavoriteState extends ConsumerState<FlippingFavorite> {
  @override
  Widget build(BuildContext context) {
    // final AsyncValue<List<CrowdFundFavorite>> crowdFundFavList = ref.watch(
    //     getCrowdFundFavourites);
    final AsyncValue<List<FavouriteFlippingModel>> flippingModel =
        ref.watch(getFlippingFund);
    return Scaffold(
        body: flippingModel.when(data: (data) {
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
                      context.push("/flipping_desc/${data[index].id}");
                    },
                    width: MediaQuery.of(context).size.width,
                    propertyName: data[index].title! ?? "",
                    location: data[index].streetLocation! ?? "",
                    propertySize: data[index].size! ?? "",
                    propertyType: data[index].type!,
                    roomNumber: data[index].rooms == null
                        ? ""
                        : data[index].rooms!.toString(),
                    propertyPrice: data[index].price,
                    favourite: true,
                    thumbnail: data[index].thumbnail!,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            });
      }
    }, error: (error, _) {
      return Text("Unable to fetch at the moment");
    }, loading: () {
      return Center(
        child: SpinKitCubeGrid(
          color: blackGrey,
          size: 20,
        ),
      );
    }));
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
