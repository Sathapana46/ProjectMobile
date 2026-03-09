import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_item_page.dart';
import 'package:flutter_application_1/pages/edit_item_page.dart';
import '../services/api_service.dart';
import '../models/item.dart';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Item> items = [];
  bool loading = true;

  load() async {
    items = await ApiService.getItems();

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  // ===============================
  // DELETE DIALOG
  // ===============================
  showDeleteDialog(Item item) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete Item"),
            ],
          ),

          content: Text("Are you sure you want to delete ${item.name}?"),

          actions: [
            TextButton(
              child: Text("Cancel"),

              onPressed: () {
                Navigator.pop(context);
              },
            ),

            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),

              onPressed: () async {
                await ApiService.deleteItem(item.id);

                Navigator.pop(context);

                load(); // refresh list
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Items")),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,

              itemBuilder: (c, i) {
                var item = items[i];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                  child: ListTile(
                    leading: Icon(Icons.devices, size: 35),

                    title: Text(
                      item.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text("${item.code} • ${item.location}"),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.status,
                          style: TextStyle(
                            color: item.status == "ใช้งาน"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        SizedBox(width: 10),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),

                          onPressed: () {
                            showDeleteDialog(item);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),

                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditItemPage(item: item),
                              ),
                            );

                            load(); // refresh
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddItemPage()),
          );

          load(); // refresh หลังเพิ่ม
        },
      ),
    );
  }
}
