import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import '../../../../features/order/model/ordered_model.dart';
import '../../../../features/order/requests/order_requests.dart';
import '../../../colors.dart';
import '../specific_property.dart';

class AttainedProperty extends ConsumerStatefulWidget {
  const AttainedProperty({Key? key}) : super(key: key);

  @override
  ConsumerState<AttainedProperty> createState() => _AttainedPropertyState();
}

class _AttainedPropertyState extends ConsumerState<AttainedProperty> {
  @override
  Widget build(BuildContext context) {
    // final AsyncValue<List<CrowdFundFavorite>> crowdFundFavList = ref.watch(
    //     getCrowdFundFavourites);
    final AsyncValue<List<OrderedModel>> crowdFundFavorites =
        ref.watch(userOrders(ref.read(profile_Provider.notifier).state.id!));
    return Scaffold(
        body: crowdFundFavorites.when(data: (data) {
      if (data.isEmpty) {
        return noListing();
      } else {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            if (data[index].crowdFund != null &&
                data[index].property == null &&
                data[index].flipping == null) {
              return Container(
                // <-- Add return statement here
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: propertyListing(
                  // status: data[index]
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
              );
            } else if (data[index].property != null &&
                data[index].flipping == null &&
                data[index].crowdFund == null) {
              return Container(
                // <-- Add return statement here
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: propertyListing(
                  // status: data[index]
                  onTap: () {
                    context.push(
                        "/property/" + data[index].property!.id! + "/current");
                  },
                  width: MediaQuery.of(context).size.width,
                  propertyName: data[index].property?.title! ?? "",
                  location: data[index].property?.streetLocation! ?? "",
                  propertySize: data[index].property!.size! ?? "",
                  propertyType: data[index].property?.type!,
                  roomNumber: data[index].property!.rooms == null
                      ? ""
                      : data[index].property!.rooms!.toString(),
                  propertyPrice: data[index].property?.targetFund,
                  favourite: true,
                  thumbnail: data[index].property!.thumbnail!,
                ),
              );
            } else if (data[index].flipping != null &&
                data[index].property == null &&
                data[index].crowdFund == null) {
              return Container(
                // <-- Add return statement here
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: propertyListing(
                  saveType: "flipping",
                  onTap: () {
                    context.push("/flipping_desc/${data[index].id}");
                  },
                  thumbnail: data[index].flipping!.thumbnail!,
                  width: MediaQuery.of(context).size.width,
                  id: data[index].flipping?.id!,
                  propertyName: data[index].flipping!.title!,
                  location: data[index].flipping!.location!,
                  propertySize: data[index].flipping!.size!,
                  propertyType: data[index].flipping!.type!,
                  roomNumber: data[index].flipping!.rooms,
                  propertyPrice: data[index].flipping!.price,
                ),
              );
            } else {
              return SizedBox(); // <-- Add a fallback return statement
            }
          },
        );
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
            alignment: Alignment.center,
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
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "You have no funded property",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }
}
