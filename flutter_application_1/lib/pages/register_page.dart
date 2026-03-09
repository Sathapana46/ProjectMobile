import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullname = TextEditingController();

  register() async {
    bool ok = await ApiService.register(
      username.text,
      password.text,
      fullname.text,
    );

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("สมัครสำเร็จ")));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("สมัครไม่สำเร็จ")));
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
                  child: Icon(Icons.person_add, color: Colors.green, size: 40),
                ),

                SizedBox(height: 10),

                Text(
                  "สมัครสมาชิก",
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
                    icon: Icons.badge,
                    hint: "Fullname",
                    controller: fullname,
                  ),

                  buildInput(
                    icon: Icons.person,
                    hint: "Username",
                    controller: username,
                  ),

                  buildInput(
                    icon: Icons.lock,
                    hint: "Password",
                    controller: password,
                    password: true,
                  ),

                  SizedBox(height: 10),

                  /// Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1e40af),
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("สมัครสมาชิก"),
                    ),
                  ),

                  SizedBox(height: 10),

                  /// Back Login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("กลับไป Login"),
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
