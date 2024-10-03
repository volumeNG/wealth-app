import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/pages/components/chat/chatting/reply_box.dart';

import '../../../../../features/chat/models/MessageBox.dart';
import '../../../../font_sizes.dart';
import '../../../chatting_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserText extends StatelessWidget {
  const UserText(
      {super.key,
      required this.formattedDate,
      required this.text,
      // required this.name,
      this.repliedTo = null});

  final String formattedDate;
  final String text;

  // final String name;
  final Reply? repliedTo;

  @override
  Widget build(BuildContext context) {
    Color tagColor;
    String? role = repliedTo?.sendBy?.role;
    if (role != "admin" && repliedTo?.sendBy?.isChampion == true) {
      tagColor = championHeaderColor;
    } else if (role == "admin") {
      tagColor = adminHeaderColor;
    } else {
      tagColor = Colors.black;
    }
    bool isThereReply = repliedTo != null &&
        repliedTo!.sendBy != null &&
        repliedTo!.sendBy!.id != null &&
        repliedTo!.sendBy!.id.toString().isNotEmpty;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          // width: MediaQuery.of(context).size.width * 0.8,
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          margin: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            // Align content to the right
            children: [
              Flexible(
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                        bottomLeft: Radius.circular(10.r),
                      ),
                      color: Color(0xff282829),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isThereReply
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5.sp),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7.sp, horizontal: 10.sp),
                                  decoration: BoxDecoration(
                                    color: tagColor.withOpacity(0.3),
                                    border: Border(
                                      left: BorderSide(
                                          color: tagColor, width: 5.0),
                                    ),
                                  ),
                                  child: ReplyBox(
                                      userReply: true,
                                      tagColor: tagColor,
                                      reply: ReplyMessage(
                                          message: repliedTo?.text,
                                          name: repliedTo?.sendBy?.name,
                                          canReply: false)),
                                ),
                              )
                            : SizedBox.shrink(),
                        isThereReply
                            ? SizedBox(
                                height: 9.sp,
                              )
                            : SizedBox.shrink(),
                        Text(
                          text,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: text__sm,
                              color: Colors.white),
                        ),
                        isThereReply
                            ? SizedBox.shrink()
                            : text.length < 8
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  )
                                : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formattedDate,
                              style: GoogleFonts.roboto(
                                color: Color(0xff86868A),
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
