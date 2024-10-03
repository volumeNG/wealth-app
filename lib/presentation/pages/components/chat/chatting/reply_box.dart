import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../font_sizes.dart';
import '../../../chatting_page.dart';

class ReplyBox extends StatelessWidget {
  ReplyBox(
      {super.key, required this.reply, this.userReply = false, this.tagColor});

  final bool? userReply;
  final ReplyMessage reply;
  Color? tagColor;

  @override
  Widget build(BuildContext context) {
    if (userReply! && tagColor == Colors.black) {
      tagColor = Colors.white;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reply.name ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: text__sm,
              color: tagColor ?? Colors.black
              ),
        ),
        Text(
          reply.message ?? '',
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: text__sm,
              color: userReply! ? Colors.white : Colors.black),
        ),
        if (userReply! && reply.message!.length < 40)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
          ),
      ],
    );
  }
}
