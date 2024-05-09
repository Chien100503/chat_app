import 'package:app_chat/pages/auth/forgot_password.dart';
import 'package:app_chat/pages/auth/sign_in.dart';
import 'package:app_chat/pages/home.dart';
import 'package:app_chat/service/database.dart';
import 'package:app_chat/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;

  String email = "", password = "", username = "", id = "";
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      QuerySnapshot querySnapshot =
          await DatabaseMethod().getUserByEmail(email);

      email = "${querySnapshot.docs[0]["Email"]}";
      id = querySnapshot.docs[0].id;

      await SharedPrefHelper().saveUserId(id);
      await SharedPrefHelper().saveUserDisplayName(email);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email không được tìm thấy')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Mật khẩu đã sai')));
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
                Text('Đăng nhập bằng số điện thoại hoặc tài khoản Facebook',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 17,
                ),
                // Textfield--------------------------------
                SizedBox(
                  height: 60,
                  child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: 'Số điện thoại hoặc email',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập mật khẩu';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: 'Mật khẩu',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        shape: CircleBorder(),
                        activeColor: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Lưu thông tin đăng nhập',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white30),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                        });
                        login();
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.blueGrey),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white38),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.blueGrey),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    child: Text(
                      'Tạo tài khoản mới',
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage(),));
                  },
                  child: Center(
                      child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
