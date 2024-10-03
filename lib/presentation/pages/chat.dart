import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/presentation/font_sizes.dart';
import 'package:wealth/presentation/pages/components/chat/admin_chat.dart';
import 'package:wealth/presentation/pages/components/chat/champions_chat.dart';
import 'package:wealth/presentation/pages/components/chat/investors_chat.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  final PageController _controller = PageController(initialPage: 0);
  int pageIndex = 0;

  var chatWidgets;

  @override
  Widget build(BuildContext context) {
    var userStatus = ref.read(profile_Provider.notifier).state;
    if (userStatus.isChampion! && userStatus.role! != "superAdmin") {
      chatWidgets = [InvestorChat(), ChampionsChat()];
    } else if (userStatus.role! == "user") {
      chatWidgets = [InvestorChat()];
    } else if (userStatus.role! == "admin" || userStatus.role! == "superAdmin") {
      chatWidgets = [
        InvestorChat(),
        ChampionsChat(),
        AdminChat(),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chat",
                    style: secondaryHeader,
                  ),
                  // InkWell(
                  //   child: ImageIcon(AssetImage("assets/images/search.png")),
                  // )
                ],
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
                        "Investors",
                        style: GoogleFonts.poppins(
                          fontWeight: pageIndex == 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: text__md,
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
                        width: MediaQuery.of(context).size.width * 0.28,
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
                        "Champions",
                        style: GoogleFonts.poppins(
                          fontWeight: pageIndex == 1
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: text__md,
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
                        width: MediaQuery.of(context).size.width * 0.28,
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
                  Column(
                    children: [
                      Text(
                        "Admins",
                        style: GoogleFonts.poppins(
                          fontWeight: pageIndex == 2
                              ? FontWeight.w500
                              : FontWeight.w400,
                          fontSize: text__md,
                          color: pageIndex == 2
                              ? Color(0xff282829)
                              : Color(0xff6B6B6F),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          color: pageIndex == 2
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
                height: 10,
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
                  children: chatWidgets,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
