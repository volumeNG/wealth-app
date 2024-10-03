import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/favourite/models/crowdfund_favorite.dart';
import '../../../../features/favourite/requests/favourite_requests.dart';
import '../specific_property.dart';

class CrowdFundFavorite extends ConsumerStatefulWidget {
  const CrowdFundFavorite({Key? key}) : super(key: key);

  @override
  ConsumerState<CrowdFundFavorite> createState() => _CrowdFundFavoriteState();
}

class _CrowdFundFavoriteState extends ConsumerState<CrowdFundFavorite> {
  @override
  Widget build(BuildContext context) {
    // final AsyncValue<List<CrowdFundFavorite>> crowdFundFavList = ref.watch(
    //     getCrowdFundFavourites);
    final AsyncValue<List<CrowdfundFavourite>> crowdFundFavorites =
        ref.watch(getCrowdFundFavourites);
    return Scaffold(
        body: crowdFundFavorites.when(data: (data) {
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
                          data[index].crowdFund!.id! +
                          "/homepage");
                    },
                    width: MediaQuery.of(context).size.width,
                    propertyName: data[index].crowdFund?.title! ?? "",
                    location: data[index].crowdFund?.streetLocation! ?? "",
                    propertySize: data[index].crowdFund!.size! ?? "",
                    propertyType: data[index].crowdFund?.type!,
                    roomNumber: data[index].crowdFund!.rooms == null
                        ? ""
                        : data[index].crowdFund!.rooms!.toString(),
                    propertyPrice: data[index].crowdFund?.targetFund,
                    favourite: true,
                    thumbnail: data[index].crowdFund!.thumbnail!,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 100,
            // padding: EdgeInsets.all(5),
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
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "You have no listed property",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Your flipping (Buy/Sell) page is empty. you can add new home,apartment land or villa here to sell.",
          softWrap: true,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              color: Color(0xff6B6B6F),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp),
        ),
      ],
    );
  }
}
