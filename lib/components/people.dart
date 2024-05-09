import 'package:app_chat/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            backgroundColor: Color(0xff81AA66),
            foregroundColor: Colors.white,
            icon: Icons.more_rounded,
            label: 'Thêm',
            onPressed: (BuildContext context) {},
          ),
          SlidableAction(
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete_forever,
            label: 'Delete',
            onPressed: (BuildContext context) {},
          ),
        ],
      ),
      child: Card(
        color: Colors.white10,
        child: ListTile(
          leading: Dialog.fullscreen(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 70,
              width: 60,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: AssetImage('assets/user1.png'), fit: BoxFit.fill)),
            ),
          ),
          title: Text(
            'User1',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
          ),
          subtitle: Text('abc'),
          trailing: Column(
            children: [
              Text('17h'),
              SizedBox(height: 5,),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(image: AssetImage('assets/user1.png'))),
              ),
            ],
          ),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(name: data),));
          },
        ),
      ),
    );
  }
}
