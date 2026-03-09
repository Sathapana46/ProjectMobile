import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_item_page.dart';
import 'package:flutter_application_1/pages/dashboard_page.dart';
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

  for (var i in items) {
    print(i.image);
  }

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
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await ApiService.deleteItem(item.id);

                Navigator.pop(context);

                load() ;
              },
            ),
          ],
        );
      },
    );
  }

  // ===============================
  // BUILD UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DashboardPage()),
              );
            },
          ),
        ],
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (c, i) {
                var item = items[i];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 3,

                  child: ListTile(
                    // ===============================
                    // IMAGE
                    // ===============================
                    leading: item.image != null && item.image != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "${ApiService.baseUrl}/uploads/${item.image}",
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              headers: {
                                "ngrok-skip-browser-warning": "true",
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 55,
                                  height: 55,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 55,
                                  height: 55,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[500],
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.devices,
                              size: 30,
                              color: Colors.grey[600],
                            ),
                          ),

                    // ===============================
                    // NAME
                    // ===============================
                    title: Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    // ===============================
                    // CODE + LOCATION
                    // ===============================
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Code: ${item.code}"),
                        Text("Location: ${item.location}"),
                      ],
                    ),

                    // ===============================
                    // ACTIONS
                    // ===============================
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // STATUS
                        Text(
                          item.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item.status == "ปกติ"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        SizedBox(width: 10),

                        // DELETE
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDeleteDialog(item);
                          },
                        ),

                        // EDIT
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditItemPage(item: item),
                              ),
                            );

                            load();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // ===============================
      // ADD BUTTON
      // ===============================
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddItemPage()),
          );

          load();
        },
      ),
    );
  }
}