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
              leading: Image.asset("assets/desk.jpg", width: 50),

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
