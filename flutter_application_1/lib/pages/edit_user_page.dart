import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditUserPage extends StatefulWidget {
  final Map user;

  const EditUserPage({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController usernameController;

  String role = "user";

  bool loading = false;

  @override
  void initState() {
    super.initState();

    usernameController =
        TextEditingController(text: widget.user["username"]);

    role = widget.user["role"];
  }

  // ========================
  // UPDATE USER
  // ========================
  updateUser() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    await ApiService.updateUser(
      widget.user["id"],
      usernameController.text,
      role,
    );

    setState(() {
      loading = false;
    });

    Navigator.pop(context);
  }

  // ========================
  // UI
  // ========================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User"),
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
                  onPressed: loading ? null : updateUser,

                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Update User",
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