import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item.dart';

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
			activeCount = items.where((i) => i.status == "ใช้งาน").length;
			repairCount = items.where((i) => i.status == "ซ่อม").length;
			brokenCount = items.where((i) => i.status == "เสีย").length;
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
									Text("สรุปจำนวนอุปกรณ์แต่ละสถานะ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
									SizedBox(height: 24),
									Card(
										color: Colors.green[100],
										child: ListTile(
											leading: Icon(Icons.check_circle, color: Colors.green, size: 40),
											title: Text("ใช้งานได้", style: TextStyle(fontSize: 18)),
											trailing: Text("$activeCount", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
										),
									),
									SizedBox(height: 16),
									Card(
										color: Colors.orange[100],
										child: ListTile(
											leading: Icon(Icons.build, color: Colors.orange, size: 40),
											title: Text("ซ่อม", style: TextStyle(fontSize: 18)),
											trailing: Text("$repairCount", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
										),
									),
									SizedBox(height: 16),
									Card(
										color: Colors.red[100],
										child: ListTile(
											leading: Icon(Icons.cancel, color: Colors.red, size: 40),
											title: Text("เสีย", style: TextStyle(fontSize: 18)),
											trailing: Text("$brokenCount", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
										),
									),
								],
							),
						),
		);
	}
}
