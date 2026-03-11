import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item.dart';
import 'status_items_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int activeCount = 0;
  int repairCount = 0;
  int brokenCount = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStatusCounts();
  }

  Future<void> loadStatusCounts() async {
    List<Item> items = await ApiService.getItems();

    setState(() {
      activeCount = items.where((i) => i.status == "ปกติ").length;
      repairCount = items.where((i) => i.status == "ชำรุดรอซ่อม").length;
      brokenCount = items.where((i) => i.status == "จำหน่ายออก").length;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard สถานะอุปกรณ์")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "สรุปจำนวนอุปกรณ์แต่ละสถานะ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),

                  /// ใช้งานได้
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatusItemsPage(status: "ปกติ"),
                        ),
                      );

                      loadStatusCounts(); // reload dashboard
                    },
                    child: Card(
                      color: Colors.green[100],
                      child: ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 40,
                        ),
                        title: Text("ปกติ", style: TextStyle(fontSize: 18)),
                        trailing: Text(
                          "$activeCount",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  /// ซ่อม
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatusItemsPage(status: "ชำรุดรอซ่อม"),
                        ),
                      );

                      loadStatusCounts(); // reload dashboard
                    },
                    child: Card(
                      color: Colors.orange[100],
                      child: ListTile(
                        leading: Icon(
                          Icons.build,
                          color: Colors.orange,
                          size: 40,
                        ),
                        title: Text(
                          "ชำรุดรอซ่อม",
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Text(
                          "$repairCount",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  /// เสีย
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatusItemsPage(status: "จำหน่ายออก"),
                        ),
                      );

                      loadStatusCounts();
                    },
                    child: Card(
                      color: Colors.red[100],
                      child: ListTile(
                        leading: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 40,
                        ),
                        title: Text(
                          "จำหน่ายออก",
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Text(
                          "$brokenCount",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
