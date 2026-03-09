import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item.dart';

class DeleteItemPage extends StatefulWidget {
  @override
  _DeleteItemPageState createState() => _DeleteItemPageState();
}

class _DeleteItemPageState extends State<DeleteItemPage> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  loadItems() async {
    items = await ApiService.getItems();
    setState(() {});
  }

  deleteItem(id) async {
    await ApiService.deleteItem(id);

    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ลบครุภัณฑ์")),

      body: ListView.builder(
        itemCount: items.length,

        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            margin: EdgeInsets.all(10),

            child: ListTile(
              leading: item.image != null && item.image != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "${ApiService.baseUrl}/uploads/${item.image}",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        headers: {
                          "ngrok-skip-browser-warning": "true",
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 50,
                            height: 50,
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
                            width: 50,
                            height: 50,
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
                      width: 50,
                      height: 50,
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

              title: Text(item.name),

              subtitle: Text("Code: ${item.code}"),

              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),

                onPressed: () {
                  showDialog(
                    context: context,

                    builder: (_) => AlertDialog(
                      title: Text("ยืนยันการลบ"),

                      content: Text("ต้องการลบ ${item.name} ?"),

                      actions: [
                        TextButton(
                          child: Text("ยกเลิก"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        TextButton(
                          child: Text("ลบ"),
                          onPressed: () async {
                            await deleteItem(item.id);

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
