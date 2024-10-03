import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealth/features/faq/requests/faq_requests.dart';
import 'package:wealth/features/support/requests/ai_support.dart';
import 'package:wealth/presentation/colors.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import '../../features/faq/models/faq_model.dart';
import 'components/chat/chatting/others_message.dart';

// todo: make it a searchable list view.
class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  final aiQuestion = TextEditingController();
  bool displayAi = false;
  bool buttonDisabled = true;
  bool sendingQuestion = true;
  String aiResponse = "";

  sendQuestion(String question) async {
    FocusScope.of(context).unfocus();
    setState(() {
      displayAi = true;
      buttonDisabled = true;
      sendingQuestion = true;
    });
    final response = await sendAiQuestion(question);
    if (response["success"]) {
      aiResponse = response["data"];
      setState(() {
        buttonDisabled = false;
        sendingQuestion = false;
      });
      aiQuestion.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<FAQ>> getFAQs = ref.watch(getFAQList);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: Text(
            "Frequent Questions",
            style: secondaryHeader,
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
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            displayAi
                ? Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              ),
                          child: sendingQuestion
                              ? Center(
                                  child: SpinKitChasingDots(
                                    size: 30,
                                    color: blackGrey,
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: OtherUser(
                                    formattedDate: "",
                                    text: aiResponse,
                                    name: "Response",
                                    thumbnail: null,
                                    ai: true,
                                  ),
                                ),
                        ),
                        Positioned(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                displayAi = false;
                                buttonDisabled = true;
                              });
                              aiQuestion.text = "";
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 0),
                                      color: Colors.black12.withOpacity(.3),
                                      blurRadius: 9,
                                    )
                                  ]),
                              child: Text(
                                "Back to Faq",
                              ),
                            ),
                          ),
                          bottom: 0,
                        )
                      ],
                    ),
                  )
                : getFAQs.when(
                    data: (data) {
                      return Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border: Border.all(
                                    color: Color(0xffE6E6E7),
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.all(1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: Colors.white,
                                    child: ExpansionTile(
                                      collapsedBackgroundColor: Colors.white,
                                      collapsedIconColor: Color(0xff200E32),
                                      collapsedShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      iconColor: Color(0xff200E32),
                                      tilePadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: Text(
                                        data[index].question!,
                                        style: GoogleFonts.inter(
                                          color: Color(0xff282829),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            data[index].ans!,
                                            style: GoogleFonts.poppins(
                                              color: Color(0xff6B6B6F),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    error: (error, _) {
                      return Center(
                        child: Text("unable to fetch data"),
                      );
                    },
                    loading: () {
                      return Expanded(
                        child: Center(
                          child: SpinKitCubeGrid(
                            size: 29,
                            color: blackGrey,
                          ),
                        ),
                      );
                    },
                  ),
            Container(
              height: 85,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Type your query",
                  //   style: GoogleFonts.poppins(
                  //     color: Color(0XFF686868),
                  //   ),
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            // barrierDismissible: false,
                            builder: (context) => SupportDetails(),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/support.png",
                            scale: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffEC9414),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          // height: 200,
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffE6E6E7),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: aiQuestion,
                                  onChanged: (value) {
                                    if (value.length > 0) {
                                      setState(() {
                                        buttonDisabled = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Aa",
                                    contentPadding: EdgeInsets.all(0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  buttonDisabled
                                      ? () {}
                                      : sendQuestion(aiQuestion.text);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: buttonDisabled
                                          ? secondaryTextColor
                                          : secondaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportDetails extends StatelessWidget {
  const SupportDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: null,
      content: Container(
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    "Would you like to contact with our support? please follow this Support ",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
                children: [
                  TextSpan(
                    text: "Contact ",
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: "and ",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "Email ",
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      color: Color(0xff200E32),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "+234 487 978 9787",
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Color(0xff200E32),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "sales@wealthapp.live",
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Item {
  String title;
  String information;

  Item(this.title, this.information);
}
