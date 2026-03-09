import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_item_page.dart';
import 'package:flutter_application_1/pages/dashboard_page.dart';
import 'package:flutter_application_1/pages/deleteItem_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'item_list_page.dart';
import 'scan_page.dart';

class HomePage extends StatelessWidget {
  Widget menuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: iconColor),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ระบบตรวจเช็คครุภัณฑ์"), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Asset System",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            ListTile(
              leading: Icon(Icons.list),
              title: Text("รายการครุภัณฑ์"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ItemListPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.qr_code),
              title: Text("Scan QR Code"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScanPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("ออกจากระบบ"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            menuCard(
              context,
              "เพิ่มครุภัณฑ์",
              Icons.add,
              Colors.blueGrey.shade200,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddItemPage()),
                );
              },
            ),

            menuCard(
              context,
              "เลือกครุภัณฑ์",
              Icons.menu,
              Colors.orange.shade200,
              Colors.deepOrange,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ItemListPage()),
                );
              },
            ),

            menuCard(
              context,
              "Scan QR Code",
              Icons.qr_code_scanner,
              Colors.green,
              Colors.white,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScanPage()),
                );
              },
            ),

            menuCard(
              context,
              "ลบรายการครุภัณฑ์",
              Icons.delete,
              Colors.red.shade200,
              Colors.red,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DeleteItemPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
