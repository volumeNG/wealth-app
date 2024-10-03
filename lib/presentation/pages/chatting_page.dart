import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:wealth/features/chat/models/MessageBox.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/widgets/shared/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/utilities.dart';
import '../../features/chat/requests/chat_requests.dart';
import '../colors.dart';
import '../font_sizes.dart';
import 'components/chat/chatting/others_message.dart';
import 'components/chat/chatting/own_message.dart';
import 'components/chat/chatting/reply_box.dart';
import 'homepage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final allMessagesProvider =
    StateProvider.autoDispose<List<MessageBox>>((ref) => []);

class ReplyMessage {
  String? name;
  String? message;
  bool? canReply = false;
  String? replyId;

  ReplyMessage(
      {this.name = "", this.message = "", this.canReply, this.replyId});
}

class ReplyNotifier extends StateNotifier<ReplyMessage> {
  ReplyNotifier() : super(ReplyMessage());

  void setReply(ReplyMessage reply) {
    state = reply;
  }

  void clearReply() {
    // state = ReplyMessage();
    state = ReplyMessage(name: "", message: "", canReply: false, replyId: null);
  }
}

class RealTimeUpdate extends StateNotifier<List<MessageBox>> {
  RealTimeUpdate() : super([]);

  dynamic setChat(List<MessageBox> messages) {
    // state = messages;\
    Future.microtask(() {
      state = messages;
    });
  }

  void addMessage(MessageBox message) {
    state = [...state, message];
  }
}

final realTimeUpdateProvider =
    StateNotifierProvider.autoDispose<RealTimeUpdate, List<MessageBox>>((ref) {
  return RealTimeUpdate();
});

final replyProvider =
    StateNotifierProvider.autoDispose<ReplyNotifier, ReplyMessage>(
        (ref) => ReplyNotifier());

//For the previous chats, we checkif there is a reply , if there is then we do the box, so we need a box for the reply
//if we want to reply we show the box at the bottom with an x
class ChattingPage extends ConsumerStatefulWidget {
  const ChattingPage({Key? key, required this.id, required this.chatGroupName})
      : super(key: key);

  final String id;
  final String chatGroupName;

  @override
  ConsumerState<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends ConsumerState<ChattingPage> {
  bool disableButton = true;
  int _currentPage = 1;
  int _limitTimes = 0;
  Timer? timer;
  String formattedDate = DateFormat('h:mm a').format(DateTime.now());
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  FocusNode _focusNode = FocusNode();
  bool _isLoadingMore = false;

  late IO.Socket _socket;

  void _connectSocket() {
    _socket = IO.io(dotenv.env["CHAT_SOCKET_URL"]!, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5, // Adjust the number of reconnection attempts
      'reconnectionDelay': 2000, // Adjust the delay between reconnections in ms
    });

    _socket.onConnect((_) {
      print('Connected to the server');
      _socket.emit('join-room', [widget.id]);
    });

    _socket.onConnectError((data) {
      print('Connection Error: $data');
    });

    _socket.onConnectTimeout((data) {
      print('Connection Timeout: $data');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from the server');
    });

    _socket.on('send-message', (data) {
      // print('Message received: $data');
    });
    _socket.on('receive-message', (data) {
      //when a new message is recieved then the list still pops even if it isn't me that recieved it
      ///checck if the user id that sends is the same as yours
      // && ref.read(allMessagesProvider.notifier).state[length].id
      var length = ref.read(allMessagesProvider.notifier).state.length - 1;
      if (ref.read(realTimeUpdateProvider.notifier).state.length > 0 &&
          ref.read(allMessagesProvider.notifier).state[length].sendBy?.id ==
              ref.read(profile_Provider.notifier).state.id) {
        ref.read(realTimeUpdateProvider.notifier).state.removeLast();
        ref.read(allMessagesProvider.notifier).state.removeLast();
      }
      MessageBox message = MessageBox.fromJson(data);
      ref.read(realTimeUpdateProvider.notifier).addMessage(message);
      ref.read(allMessagesProvider.notifier).state.add(message);
      ref.read(replyProvider.notifier).clearReply();
      // _focusNode.unfocus();
    });
    _socket.connect();
  }

  leaveRoom() async {
    _socket.emit("leave-room", "${widget.id}");
    _socket.disconnect();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectSocket();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 5) {
        _loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    leaveRoom();
    _socket.disconnect(); // Disconnect the socke
    _focusNode.dispose();
    // ref.invalidate(allMessagesProvider);
    super.dispose();
  }

  Future<void> _loadMoreData() async {
    if (!_isLoadingMore && (ref.watch(totalPageNumber) > _currentPage * 15)) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage += 1; // Increment the page number
      // Trigger the fetch for the next page
      await ref.refresh(getChats(Tuple2(widget.id, _currentPage)).future);
      setState(() {
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _limitTimes += 1;
        if (_limitTimes > 2) {
          _limitTimes = 2;
        }
      });
    }
  }

  sendMessageToServer() async {
    if (urlRegExp.hasMatch(messageController.text.trim())) {
      showErrorDialog(context, "Message cannot be a link.");
      return;
    }
    FocusScope.of(context).unfocus();
    //This resets the button to be disabled
    setState(() {
      disableButton = true;
    });
    MessageBox message = MessageBox(
      text: messageController.text,
      sendById: ref.read(profile_Provider.notifier).state.id,
      createdAt: DateTime.now().toString(),
      sendBy: SendBy(
        name: ref.read(profile_Provider.notifier).state.name,
        isChampion: ref.read(profile_Provider.notifier).state.isChampion,
        role: ref.read(profile_Provider.notifier).state.role,
        id: ref.read(profile_Provider.notifier).state.id,
        email: ref.read(profile_Provider.notifier).state.email,
        profileImg: ref.read(profile_Provider.notifier).state.profileImg,
      ),
      reply: ref.read(replyProvider.notifier).state.name!.isEmpty
          ? null
          : Reply(
              text: ref.read(replyProvider.notifier).state.message,
              replyId: ref.read(replyProvider.notifier).state.replyId,
              sendBy: SendBy(
                name: ref.read(replyProvider.notifier).state.name,
                isChampion: "",
                role: "",
              ),
            ),
    );
    ref.read(realTimeUpdateProvider.notifier).addMessage(message);
    ref.read(allMessagesProvider.notifier).state.add(message);
    var textData = messageController.text;
    messageController.text = "";
    ReplyMessage replyMessage = ref.read(replyProvider.notifier).state;
    //This fetches the data from the reply box
    final response = await sendMessage(widget.id, textData.trim(),
        ref.read(replyProvider.notifier).state.replyId);

    if (response["success"]) {
      MessageBox data = MessageBox.fromJson(response["data"]);
      var sendObject = {
        "chatGroupId": data.chatGroupId,
        "text": data.text,
        "image": data.sendBy?.profileImg!,
        "replyId": data.replyId,
        "sendById": data.sendById,
        "createdAt": data.createdAt,
        "updatedAt": data.updatedAt,
        "sendBy": {
          "email": data.sendBy?.email,
          "id": data.sendBy?.id,
          "name": data.sendBy?.name,
          "role": data.sendBy?.role,
          "isChampion": data.sendBy?.isChampion.toString(),
          "profileImg": data.sendBy?.profileImg,
        },
        "reply": {
          "chatGroupId": widget.id,
          "replyId": replyMessage.replyId,
          "image": data.reply?.sendBy?.email,
          "text": replyMessage.message,
          "sendBy": {
            "email": data.reply?.sendBy?.email ?? "",
            "id": data.reply?.sendBy?.id ?? "",
            "name": data.reply?.sendBy?.name ?? replyMessage.name,
            "role": data.reply?.sendBy?.role ?? "",
            "isChampion": data.reply?.sendBy?.isChampion ?? false,
            "profileImg": data.reply?.sendBy?.profileImg ?? "",
          }
        },
      };
      ref.read(replyProvider.notifier).clearReply();
      _socket.emit("send-message", sendObject);
      _socket.emit('receive-message', [widget.id]);
      Future.delayed(Duration(milliseconds: 0700), () {
        _focusNode.unfocus();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    } else {
      showErrorDialog(context, response["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ReplyMessage>(replyProvider, (previous, next) {
      if (next.canReply == true) {
        _focusNode.requestFocus();
      }
    });

    List<MessageBox> realTimeMessages = ref.watch(realTimeUpdateProvider);

    ReplyMessage reply = ref.watch(replyProvider);

    AsyncValue<List<MessageBox>> chats =
        ref.watch(getChats(Tuple2(widget.id, _currentPage)));

    // [...realTimeMessages.reversed];

    chats.when(
      data: (data) {
        // setState(() {
        //   _isLoadingMore = false;
        // });
        // if (data.isEmpty) {
        //   return Center(
        //     child: Text("Start Conversation"),
        //   );
        // allMessages.addAll(data);
        if (ref.read(allMessagesProvider.notifier).state.length <
            ref.watch(totalPageNumber.notifier).state) {
          final existingIds = ref
              .read(allMessagesProvider.notifier)
              .state
              .map((property) => property.id)
              .toSet();

          for (var item in data) {
            if (!existingIds.contains(item.id)) {
              ref.read(allMessagesProvider.notifier).state.add(item);
              existingIds.add(item.id);
            }
          }
          // ref.read(allMessagesProvider.notifier).state.addAll(data);
        }
        // if (allMessages.isEmpty) {
        //   return Center(
        //     child: Text("Start Conversation"),
        //   );
        // } else {
        //   return Expanded(
        //     child: ListView.builder(
        //       controller: _scrollController,
        //       reverse: true,
        //       itemCount: allMessages.length,
        //       itemBuilder: (context, index) {
        //         if (allMessages[index].sendById! ==
        //             ref.read(profile_Provider.notifier).state.id) {
        //           return SizedBox(
        //             width: double.infinity,
        //             child: UserText(
        //               formattedDate: getTimeFromDateAndTime(
        //                   allMessages[index].createdAt.toString()),
        //               text: allMessages[index].text!,
        //               // name: allMessages[index].sendBy!.name!,
        //               repliedTo: allMessages[index].reply,
        //             ),
        //           );
        //         } else {
        //           return Container(
        //             width: double.infinity,
        //             child: OtherUser(
        //               replyId: allMessages[index].id,
        //               formattedDate: getTimeFromDateAndTime(
        //                   allMessages[index].createdAt.toString()),
        //               text: allMessages[index].text!,
        //               name: allMessages[index].sendBy!.name!,
        //               thumbnail: allMessages[index].image,
        //               role: bool.parse(allMessages[index]
        //                           .sendBy!
        //                           .isChampion!
        //                           .toString()) &&
        //                       allMessages[index].sendBy?.role != "admin"
        //                   ? "champion"
        //                   : allMessages[index].sendBy!.role!,
        //               repliedTo: allMessages[index].reply,
        //             ),
        //           );
        //         }
        //       },
        //     ),
        //   );
        // }
      },
      error: (error, _) {
        return Container(
          child: Center(
            child: Text("Unable to retrieve chats at the moment"),
          ),
        );
      },
      loading: () {},
    );

    final allMessages = [
      ...realTimeMessages.reversed,
      ...ref.watch(allMessagesProvider.notifier).state
    ];

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  widget.chatGroupName,
                  style: secondaryHeader,
                ),
                // Text("status"),
              ],
            ),
          ],
        ),
        leading: InkWell(
          onTap: () {
            leaveRoom();
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
                Radius.circular(1000),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _isLoadingMore
                ? Container(
                    margin: EdgeInsets.all(10),
                    child: SpinKitCubeGrid(size: 20, color: blackGrey))
                : SizedBox.shrink(),
            allMessages.isEmpty
                ? _isLoadingMore
                    ? Center(
                        child: Column(
                          children: [
                            SpinKitFadingFour(size: 15, color: blackGrey),
                            SizedBox(
                              height: 10.sp,
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text("Start Conversation"),
                      )
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        if (allMessages[index].sendById != null &&
                            allMessages[index].sendById! ==
                                ref.read(profile_Provider.notifier).state.id) {
                          return SizedBox(
                            width: double.infinity,
                            child: UserText(
                              formattedDate: getTimeFromDateAndTime(
                                  allMessages[index].createdAt.toString()),
                              text: allMessages[index].text!,
                              // name: allMessages[index].sendBy!.name!,
                              repliedTo: allMessages[index].reply,
                            ),
                          );
                        } else {
                          return Container(
                            width: double.infinity,
                            child: OtherUser(
                              replyId: allMessages[index].id,
                              formattedDate: getTimeFromDateAndTime(
                                  allMessages[index].createdAt.toString()),
                              text: allMessages[index].text!,
                              name: allMessages[index].sendBy!.name!,
                              thumbnail: allMessages[index].sendBy?.profileImg,
                              role: bool.parse(allMessages[index]
                                          .sendBy!
                                          .isChampion!
                                          .toString()) &&
                                      allMessages[index].sendBy?.role != "admin"
                                  ? "champion"
                                  : allMessages[index].sendBy!.role!,
                              repliedTo: allMessages[index].reply,
                            ),
                          );
                        }
                      },
                    ),
                  ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // reply.canReply!
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset(0, 0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: reply.canReply == true
                        ? ClipRRect(
                            key: ValueKey<bool>(reply.canReply!),
                            borderRadius: BorderRadius.circular(5.sp),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 7.sp, horizontal: 10.sp),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border(
                                  left: BorderSide(
                                      color: Colors.red.withOpacity(0.2),
                                      width: 5.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: ReplyBox(reply: reply)),
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 16,
                                      onPressed: () {
                                        _focusNode.unfocus();
                                        ref
                                            .read(replyProvider.notifier)
                                            .clearReply();
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  // : SizedBox.shrink(),
                  Form(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            // height: 200,
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 15),
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
                                    onChanged: (value) {
                                      setState(() {
                                        disableButton = value.isEmpty;
                                      });
                                    },
                                    focusNode: _focusNode,
                                    controller: messageController,
                                    cursorColor: Colors.black54,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: text__md,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Type your message ...",
                                      hintStyle: GoogleFonts.poppins(
                                        color: Color(0xff282828B2),
                                        fontSize: text__md,
                                      ),
                                      contentPadding: EdgeInsets.all(10.sp),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    maxLines: null,
                                    minLines: 1,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: disableButton
                                      ? () {}
                                      : sendMessageToServer,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: disableButton
                                          ? Colors.black12.withOpacity(0.2)
                                          : secondaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
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
                    ),
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

Color championHeaderColor = Color(0xffA1A5D4);
Color adminHeaderColor = Color(0xff5FBE56);
