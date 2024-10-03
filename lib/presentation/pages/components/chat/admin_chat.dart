import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/features/chat/requests/chat_requests.dart';

import '../../../../features/chat/models/ChatGroup.dart';
import '../../../../utilities.dart';
import '../../../colors.dart';
import '../../widgets/shared/text_styles.dart';

class AdminChat extends ConsumerStatefulWidget {
  const AdminChat({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminChat> createState() => _AdminChatState();
}

class _AdminChatState extends ConsumerState<AdminChat> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<ChatGroup>> adminChats = ref.watch(getChatLists("admin"));
    // AsyncValue<List<ChatGroup>> adminChats = ref.watch(getChatLists("null"));

    return Scaffold(
        body: adminChats.when(data: (data) {
      if (data.isNotEmpty) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                context.push("/chat/${data[index].id}/${data[index].name!}");
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15.sp),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        image: DecorationImage(
                          image: data[index].thumbnail!.isNotEmpty &&
                                  data[index].thumbnail != null
                              ? NetworkImage(data[index].thumbnail!)
                              : AssetImage("assets/images/chat_about.png")
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    data[index].name!,
                                    style: GoogleFonts.poppins(
                                      color: secondaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Text(
                                getTimeFromDateAndTime(
                                    data[index].updatedAt.toString()),
                                style: GoogleFonts.rubik(
                                  color: Color(0xffAAAAAA),
                                  fontSize: 11.sp,
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 250,
                            child: Text(
                              "Check message...",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff6B6B6F),
                                  fontSize: 11.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      } else {
        return Container(
          child: Center(
            child: Text("There are no groups",
              style: secondaryText,
            ),
          ),
        );
      }
    }, error: (error, _) {
      return Container(
        child: Center(
          child: Text("Unable to fetch data"),
        ),
      );
    }, loading: () {
      return Center(
        child: SpinKitCubeGrid(
          size: 20,
          color: blackGrey,
        ),
      );
    }));
  }
}
