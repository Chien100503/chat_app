import 'package:app_chat/pages/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String email = "";

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mật khẩu sẽ được tạo mới')));
    } on FirebaseAuthException catch(e) {
      if (e.code =="user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không tìm thấy emaili')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 16, 32, 40),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/logo.png'),
                        )),
                  ),
                ),
                Center(
                  child: Text('Quên mật khẩu',
                      style: TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                ),
                SizedBox(
                  height: 17,
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập email hoặc số diện thoại';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      hintText: 'Nhập email',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                        });
                      }
                      resetPassword();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white38),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.blueGrey),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    child: Text(
                      'Tiếp theo',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                      'Quay lại trang đăng nhập',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
