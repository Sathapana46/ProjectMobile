import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String role = "user";

  bool loading = false;

  saveUser() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    await ApiService.addUser(
      usernameController.text,
      passwordController.text,
      role,
    );

    setState(() {
      loading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              // ========================
              // USERNAME
              // ========================
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter username" : null,
              ),

              SizedBox(height: 16),

              // ========================
              // PASSWORD
              // ========================
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter password" : null,
              ),

              SizedBox(height: 16),

              // ========================
              // ROLE
              // ========================
              DropdownButtonFormField<String>(
                value: role,
                decoration: InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.admin_panel_settings),
                ),
                items: [
                  DropdownMenuItem(
                    value: "user",
                    child: Text("User"),
                  ),
                  DropdownMenuItem(
                    value: "admin",
                    child: Text("Admin"),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    role = v!;
                  });
                },
              ),

              SizedBox(height: 30),

              // ========================
              // SAVE BUTTON
              // ========================
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: loading ? null : saveUser,
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Save User",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}