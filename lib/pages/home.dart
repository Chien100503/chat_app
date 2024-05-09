// import 'package:app_chat/components/people.dart';
// import 'package:app_chat/service/database.dart';
// import 'package:app_chat/service/shared_pref.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'chat_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   bool search = false;
//
//   String? myName, myUserName, myEmail;
//   Stream? chatRoomStream;
//
//   getTheSharedPref() async {
//     myName = await SharedPrefHelper().getUserDisplayName();
//     myUserName = await SharedPrefHelper().getUserName();
//     myEmail = await SharedPrefHelper().getUserEmail();
//     setState(() {});
//   }
//
//   ontheload() async {
//     await getTheSharedPref();
//     chatRoomStream = await DatabaseMethod().getChatRooms();
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     ontheload();
//   }
//
//   getChatRoomIdByUserName(String a, String b) {
//     if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
//       return "$b\_$a";
//     } else {
//       return "$a\_$b";
//     }
//   }
//
//   var queryResultSet = [];
//   var temSearchStore = [];
//
//   initiateSearch(value) async {
//     if (value.length == 0) {
//       setState(() {
//         queryResultSet = [];
//         temSearchStore = [];
//       });
//     } else {
//       setState(() {
//         search = true;
//       });
//       var capitalizedValue =
//           value.substring(0, 1).toUpperCase() + value.substring(1);
//       if (queryResultSet.isEmpty && value.length == 1) {
//         DatabaseMethod().Search(value).then((QuerySnapshot snapshot) {
//           setState(() {
//             queryResultSet = snapshot.docs.map((doc) => doc.data()).toList();
//           });
//         });
//       } else {
//         setState(() {
//           temSearchStore = [];
//           queryResultSet.forEach((element) {
//             if (element['username'].startsWith(capitalizedValue)) {
//               temSearchStore.add(element);
//             }
//           });
//         });
//       }
//     }
//   }
//
//   Widget chatRoomList() {
//     return StreamBuilder(
//       stream: chatRoomStream,
//       builder: (context, AsyncSnapshot snapshot) {
//         return snapshot.hasData
//             ? ListView.builder(
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           itemCount: snapshot.data.docs.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot ds = snapshot.data.docs[index];
//             return ChatRoomListTitle(
//               lastMessage: ds["lastMessage"],
//               myUserName: myUserName!,
//               chatRoomId: ds.id,
//               time: ds["lastMessageSend"],
//             );
//           },
//         )
//             : Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(),
//       appBar: AppBar(
//         actions: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.85,
//             height: search
//                 ? MediaQuery.of(context).size.height / 1.19
//                 : MediaQuery.of(context).size.height / 1.15,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 search
//                     ? Expanded(
//                   child: TextField(
//                     onChanged: (value) {
//                       initiateSearch(value.toUpperCase());
//                     },
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white10,
//                       hintText: 'Tìm liên lạc',
//                       border: InputBorder.none,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 )
//                     : Text(
//                   'Đoạn chat',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       search = !search;
//                     });
//                   },
//                   icon: Icon(CupertinoIcons.search),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//         child: Column(
//           children: [
//             search
//                 ? ListView(
//               padding: EdgeInsets.only(left: 10.0, right: 10.0),
//               primary: false,
//               shrinkWrap: true,
//               children: temSearchStore.map((element) {
//                 return buildResultCard(element);
//               }).toList(),
//             )
//                 : chatRoomList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildResultCard(data) {
//     return GestureDetector(
//       onTap: () async {
//         search = false;
//         setState(() {});
//         var chatRoomId = getChatRoomIdByUserName(myUserName!, data["username"]);
//         Map<String, dynamic> chatRoomInfoMap = {
//           "user": [myUserName, data["username"]],
//         };
//         await DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatPage(
//               name: data['UserName'],
//               username: data["username"],
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8),
//         child: Material(
//           elevation: 5.0,
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             padding: EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: Colors.white12,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(data["UserName"]),
//                     Text(data["username"]),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ChatRoomListTitle extends StatefulWidget {
//   final String lastMessage, chatRoomId, myUserName, time;
//   const ChatRoomListTitle({
//     Key? key,
//     required this.lastMessage,
//     required this.chatRoomId,
//     required this.myUserName,
//     required this.time,
//   });
//
//   @override
//   State<ChatRoomListTitle> createState() => _ChatRoomListTitleState();
// }
//
// class _ChatRoomListTitleState extends State<ChatRoomListTitle> {
//   String name = "", username = "", id = "";
//
//   getThisUserInfo() async {
//     username = widget.chatRoomId
//         .replaceAll("-", "")
//         .replaceAll(widget.myUserName, "");
//     QuerySnapshot querySnapshot =
//     await DatabaseMethod().getUserInfo(username);
//     name = "${querySnapshot.docs[0]["UserName"]}";
//     id = "${querySnapshot.docs[0].id}";
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     getThisUserInfo();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(widget.lastMessage),
//       ],
//     );
//   }
// }

import 'package:app_chat/service/database.dart';
import 'package:app_chat/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool search = false;

  String? myName, myUserName, myEmail;
  Stream? chatRoomStream;

  getTheSharedPref() async {
    myName = await SharedPrefHelper().getUserDisplayName();
    myUserName = await SharedPrefHelper().getUserName();
    myEmail = await SharedPrefHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getTheSharedPref();
    chatRoomStream = await DatabaseMethod().getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getChatRoomIdByUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryResultSet = [];
  var temSearchStore = [];

  initiateSearch(value) async {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        temSearchStore = [];
      });
    } else {
      setState(() {
        search = true;
      });
      var capitalizedValue =
          value.substring(0, 1).toUpperCase() + value.substring(1);
      if (queryResultSet.isEmpty && value.length == 1) {
        DatabaseMethod().Search(value).then((QuerySnapshot snapshot) {
          setState(() {
            queryResultSet = snapshot.docs.map((doc) => doc.data()).toList();
          });
        });
      } else {
        setState(() {
          temSearchStore = [];
          queryResultSet.forEach((element) {
            if (element['username'].startsWith(capitalizedValue)) {
              temSearchStore.add(element);
            }
          });
        });
      }
    }
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return ChatRoomListTitle(
              lastMessage: ds["lastMessage"],
              myUserName: myUserName!,
              chatRoomId: ds.id,
              time: ds["lastMessageSend"],
            );
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: search
                ? MediaQuery.of(context).size.height / 1.19
                : MediaQuery.of(context).size.height / 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search
                    ? Expanded(
                  child: TextField(
                    onChanged: (value) {
                      initiateSearch(value.toUpperCase());
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      hintText: 'Tìm liên lạc',
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                )
                    : Text(
                  'Đoạn chat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      search = !search;
                    });
                  },
                  icon: Icon(CupertinoIcons.search),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Column(
          children: [
            search
                ? ListView(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              primary: false,
              shrinkWrap: true,
              children: temSearchStore.map((element) {
                return buildResultCard(element);
              }).toList(),
            )
                : chatRoomList(),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        search = false;
        setState(() {});
        var chatRoomId = getChatRoomIdByUserName(myUserName!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "user": [myUserName, data["username"]],
        };
        await DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              name: data['UserName'],
              username: data["username"],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["UserName"]),
                    Text(data["username"]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTitle extends StatefulWidget {
  final String lastMessage, chatRoomId, myUserName, time;
  const ChatRoomListTitle({
    Key? key,
    required this.lastMessage,
    required this.chatRoomId,
    required this.myUserName,
    required this.time,
  });

  @override
  State<ChatRoomListTitle> createState() => _ChatRoomListTitleState();
}

class _ChatRoomListTitleState extends State<ChatRoomListTitle> {
  String name = "", username = "", id = "";

  getThisUserInfo() async {
    username = widget.chatRoomId
        .replaceAll("-", "")
        .replaceAll(widget.myUserName, "");
    QuerySnapshot querySnapshot =
    await DatabaseMethod().getUserInfo(username);
    name = "${querySnapshot.docs[0]["UserName"]}";
    id = "${querySnapshot.docs[0].id}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(widget.myUserName),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String name, username;

  ChatPage({Key? key, required this.name, required this.username})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  String? myUserName, myEmail, myName, messageId, chatRoomId;
  Stream? messageStream;

  getTheSharedPref() async {
    myName = await SharedPrefHelper().getUserDisplayName();
    myUserName = await SharedPrefHelper().getUserName();
    myName = await SharedPrefHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getTheSharedPref();
    await getAndSetMessage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
    getAndSetMessage();
  }

  void getSharedPref() async {
    myName = await SharedPrefHelper().getUserDisplayName();
    myUserName = await SharedPrefHelper().getUserName();
    myEmail = await SharedPrefHelper().getUserEmail();
    chatRoomId = getChatRoomIdByUserName(widget.username, myUserName!);
    getAndSetMessage();
    setState(() {});
  }

  String getChatRoomIdByUserName(String a, String b) {
    return a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)
        ? "$b\_$a"
        : "$a\_$b";
  }

  Widget chatMessageTitle(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
      sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
                bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
                topRight: Radius.circular(24),
              ),
            ),
            child: Text(message),
          ),
        ),
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(bottom: 90.0, top: 130),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return chatMessageTitle(ds["message"], myUserName == ds["sendBy"]);
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void addMessage() {
    if (messageController.text.isNotEmpty) {
      final message = messageController.text;
      messageController.text = '';

      final now = DateTime.now();
      final formattedDate = DateFormat('h:mma').format(now);
      final messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp()
      };
      messageId ??= randomAlphaNumeric(10);
      DatabaseMethod()
          .addMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((_) {
        final lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName
        };
        DatabaseMethod().updateMessageSend(chatRoomId!, lastMessageInfoMap);
      });
    }
  }

  getAndSetMessage() async {
    messageStream = await DatabaseMethod().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          chatMessage(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
