import 'package:flutter/material.dart';
import 'add_user_page.dart';
import 'edit_user_page.dart';
import '../services/api_service.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<Map<String, dynamic>> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    users = await ApiService.getUsers();

    setState(() {
      loading = false;
    });
  }

  // ===============================
  // DELETE DIALOG
  // ===============================
  void showDeleteDialog(Map user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete User"),
            ],
          ),
          content: Text("Delete user ${user["username"]}?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await ApiService.deleteUser(user["id"]);

                Navigator.pop(context);

                loadUsers();
              },
            ),
          ],
        );
      },
    );
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Management")),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.person, size: 35),

                    title: Text(
                      user["username"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Text("Role: ${user["role"]}"),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ROLE
                        Text(
                          user["role"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: user["role"] == "admin"
                                ? Colors.blue
                                : Colors.green,
                          ),
                        ),

                        SizedBox(width: 10),

                        // DELETE
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDeleteDialog(user);
                          },
                        ),

                        // EDIT
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditUserPage(user: user),
                              ),
                            );

                            loadUsers();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // ===============================
      // ADD USER BUTTON
      // ===============================
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddUserPage()),
          );

          loadUsers();
        },
      ),
    );
  }
}
