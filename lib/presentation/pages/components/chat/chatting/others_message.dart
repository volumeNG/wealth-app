import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/pages/components/chat/chatting/reply_box.dart';

import '../../../../../features/chat/models/MessageBox.dart';
import '../../../../font_sizes.dart';
import '../../../chatting_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherUser extends ConsumerStatefulWidget {
  OtherUser(
      {super.key,
      required this.formattedDate,
      required this.text,
      required this.name,
      required this.thumbnail,
      this.ai = false,
      this.replyId = "",
      this.repliedTo = null,
      this.role = "user"});

  final String formattedDate;
  final String text;
  final String name;
  final dynamic thumbnail;
  final String? replyId;
  final bool ai;
  final String role;
  final Reply? repliedTo;

  @override
  ConsumerState<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends ConsumerState<OtherUser> {
  @override
  Widget build(BuildContext context) {
    Color tagColor = Colors.black;
    if (widget.role == "champion") {
      setState(() {
        tagColor = championHeaderColor;
      });
    } else if (widget.role == "superAdmin") {
      setState(() {
        tagColor = adminHeaderColor;
      });
    } else {
      setState(() {
        tagColor = Colors.black;
      });
    }
    String path = widget.role;
    // bool isThereReply =
    //     widget.repliedTo != null && widget.repliedTo?.sendBy?.id != null;

    bool isThereReply = widget.repliedTo != null &&
        widget.repliedTo!.sendBy != null &&
        widget.repliedTo!.sendBy!.id != null &&
        widget.repliedTo!.sendBy!.id.toString().isNotEmpty;

    // widget.repliedTo != null && widget.repliedTo!.replyId != null;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: IntrinsicWidth(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.ai
                            ? SizedBox.shrink()
                            : Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: widget.thumbnail != null
                                        ? NetworkImage(widget.thumbnail)
                                        : AssetImage(
                                                "assets/images/chat_profile.png")
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r),
                                bottomRight: Radius.circular(10.r),
                              ),
                              color: Color(0xffF5F5F6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    path != "user"
                                        ? ImageIcon(
                                            AssetImage("assets/images/$path.png"),
                                            size: 16.sp,
                                            color: tagColor,
                                          )
                                        : SizedBox.shrink(),
                                    path != "user"
                                        ? SizedBox(
                                            width: 4.sp,
                                          )
                                        : SizedBox.shrink(),
                                    Text(
                                      widget.name,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: text__sm,
                                          color: tagColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                isThereReply
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5.sp),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 7.sp, horizontal: 10.sp),
                                          decoration: BoxDecoration(
                                            color: tagColor.withOpacity(0.5),
                                            border: Border(
                                              left: BorderSide(
                                                  color: tagColor, width: 5.0),
                                            ),
                                          ),
                                          child: ReplyBox(
                                              tagColor: tagColor,
                                              reply: ReplyMessage(
                                                  message: widget.repliedTo?.text,
                                                  name: widget
                                                      .repliedTo?.sendBy?.name,
                                                  canReply: false)),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                widget.repliedTo != null
                                    ? SizedBox(
                                        height: 9.sp,
                                      )
                                    : SizedBox.shrink(),
                                Text(
                                  widget.text,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: text__sm,
                                  ),
                                ),
                                isThereReply
                                    ? SizedBox.shrink()
                                    : widget.text.length < 8
                                    ? SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.2,
                                )
                                    : SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.formattedDate.isNotEmpty
                                          ? widget.formattedDate
                                          : "",
                                      style: GoogleFonts.roboto(
                                          color: Color(0xff86868A),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///This can be worked on later
                IconButton(
                  onPressed: () {
                    ref.read(replyProvider.notifier).setReply(ReplyMessage(
                        name: widget.name,
                        message: widget.text,
                        replyId: widget.replyId,
                        canReply: true));
                  },
                  icon: ImageIcon(
                    AssetImage(
                      "assets/images/reply.png",
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


