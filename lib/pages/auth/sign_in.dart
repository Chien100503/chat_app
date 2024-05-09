import 'package:app_chat/pages/auth/login.dart';
import 'package:app_chat/pages/home.dart';
import 'package:app_chat/service/database.dart';
import 'package:app_chat/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String username = "", email = "", password = "", confirmPassword = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  register() async {
    if (password != null && password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String id = randomAlphaNumeric(10);
        String user = emailController.text.replaceAll('@gmail.com', '');
        String updateUserName =
            user.replaceFirst(user[0], user[0].toUpperCase());
        String firstLetter = user.substring(0,1).toUpperCase();

        Map<String, dynamic> userInfoMap = {
          "UserName": usernameController.text,
          "Email": emailController.text,
          "username": updateUserName,
          "SearchKey" : firstLetter,
          "Id": id,
        };
        await DatabaseMethod().addUserDetails(userInfoMap, id);
        await SharedPrefHelper().saveUserId(id);
        await SharedPrefHelper().saveUserDisplayName(usernameController.text);
        await SharedPrefHelper().saveUserEmail(emailController.text);
        await SharedPrefHelper()
            .saveUserName(emailController.text.replaceAll('@gmail.com', ''));

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Register successfully')));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password Provided is too weak')));
        } else if (e.code == 'email-already-in-user') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Account already exists")));
        }
      }
    }
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/logo.png'),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Đăng ký bằng số điện thoại hoặc đăng nhập tài khoản Facebook',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 17),
                // Textfield--------------------------------
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập tên người dùng';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      hintText: 'Tên người dùng',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
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
                      hintText: 'Số điện thoại hoặc email',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
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
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập lại mật khẩu';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      hintText: 'Nhập lại mật khẩu',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                    SizedBox(width: 5),
                    Text(
                      'Lưu thông tin đăng nhập',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white30,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          username = usernameController.text;
                          email = emailController.text;
                          password = passwordController.text;
                          confirmPassword = passwordController.text;
                        });
                      }
                      register();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white38),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      'Đã có tài khoản',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
