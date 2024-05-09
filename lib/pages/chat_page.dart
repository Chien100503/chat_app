// import 'package:app_chat/service/database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:random_string/random_string.dart';
//
// import '../service/shared_pref.dart';
//
// class ChatPage extends StatefulWidget {
//   final String name, username;
//
//   ChatPage({Key? key, required this.name, required this.username})
//       : super(key: key);
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   TextEditingController messageController = TextEditingController();
//   String? myUserName, myEmail, myName, messageId, chatRoomId;
//   Stream? messageStream;
//
//   getTheSharedPref() async {
//     myName = await SharedPrefHelper().getUserDisplayName();
//     myUserName = await SharedPrefHelper().getUserName();
//     myName = await SharedPrefHelper().getUserEmail();
//     setState(() {
//
//     });
//   }
//
//   ontheload() async {
//     await getTheSharedPref();
//     await getAndSetMessage();
//     setState(() {
//
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getSharedPref();
//     getAndSetMessage();
//   }
//
//   void getSharedPref() async {
//     myName = await SharedPrefHelper().getUserDisplayName();
//     myUserName = await SharedPrefHelper().getUserName();
//     myEmail = await SharedPrefHelper().getUserEmail();
//     chatRoomId = getChatRoomIdByUserName(widget.username, myUserName!);
//     getAndSetMessage();
//     setState(() {});
//   }
//
//   String getChatRoomIdByUserName(String a, String b) {
//     return a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)
//         ? "$b\_$a"
//         : "$a\_$b";
//   }
//
//   Widget chatMessageTitle(String message, bool sendByMe) {
//     return Row(
//       mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment
//           .start,
//       children: [
//         Flexible(
//             child: Container(
//               padding: EdgeInsets.all(16),
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(24),
//                     bottomRight: sendByMe ? Radius.circular(0) : Radius
//                         .circular(24),
//                     bottomLeft: sendByMe ? Radius.circular(24) : Radius
//                         .circular(0),
//                     topRight: Radius.circular(24),
//                   )
//               ),
//               child: Text(message),
//             ))
//       ],
//     );
//   }
//
//   Widget chatMessage() {
//     return StreamBuilder(
//       stream: messageStream, // Đảm bảo bạn đã cung cấp messageStream
//       builder: (context, AsyncSnapshot snapshot) {
//         return snapshot.hasData ? ListView.builder(
//           reverse: true,
//           padding: EdgeInsets.only(bottom: 90.0, top: 130),
//           itemCount: snapshot.data.docs.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot ds = snapshot.data.docs[index];
//             return chatMessageTitle(ds["message"], myUserName == ds["sendBy"]);
//           },
//         ): Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
//
//
//   void addMessage() {
//     if (messageController.text.isNotEmpty) {
//       final message = messageController.text;
//       messageController.text = '';
//
//       final now = DateTime.now();
//       final formattedDate = DateFormat('h:mma').format(now);
//       final messageInfoMap = {
//         "message": message,
//         "sendBy": myUserName,
//         "ts": formattedDate,
//         "time": FieldValue.serverTimestamp()
//       };
//       messageId ??= randomAlphaNumeric(10);
//       DatabaseMethod()
//           .addMessage(chatRoomId!, messageId!, messageInfoMap)
//           .then((_) {
//         final lastMessageInfoMap = {
//           "lastMessage": message,
//           "lastMessageSendTs": formattedDate,
//           "time": FieldValue.serverTimestamp(),
//           "lastMessageSendBy": myUserName
//         };
//         DatabaseMethod().updateMessageSend(chatRoomId!, lastMessageInfoMap);
//       });
//     }
//   }
//   getAndSetMessage() async{
//     messageStream = await DatabaseMethod().getChatRoomMessages(chatRoomId);
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.name),
//       ),
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           chatMessage(), // Ở đây bạn giữ lại một lần gọi chatMessage()
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: addMessage,
//                   icon: Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

