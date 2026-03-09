import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  login() async {
    bool ok = await ApiService.login(user.text, pass.text);

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed")));
    }
  }

  Widget buildInput({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool password = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: password,
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: Column(
        children: [
          /// Header
          Container(
            height: 220,
            width: double.infinity,
            color: Color(0xff3f51b5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.check, color: Colors.green, size: 40),
                ),

                SizedBox(height: 10),

                Text(
                  "ระบบตรวจเช็คครุภัณฑ์",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          /// Form
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  buildInput(
                    icon: Icons.person,
                    hint: "Username",
                    controller: user,
                  ),

                  buildInput(
                    icon: Icons.lock,
                    hint: "Password",
                    controller: pass,
                    password: true,
                  ),

                  SizedBox(height: 10),

                  /// Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1e40af),
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("เข้าสู่ระบบ"),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text("หรือ"),

                  SizedBox(height: 10),

                  /// Register
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterPage()),
                      );
                    },
                    child: Text("Create Account"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
