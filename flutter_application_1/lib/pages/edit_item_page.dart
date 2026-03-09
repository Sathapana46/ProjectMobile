import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class EditItemPage extends StatefulWidget {
  final Item item;

  const EditItemPage({Key? key, required this.item}) : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final codeController = TextEditingController();
  final locationController = TextEditingController();

  String status = "ปกติ";

  final baseUrl = "https://teresa-semiradical-odilia.ngrok-free.dev";

  @override
  void initState() {
    super.initState();

    nameController.text = widget.item.name;
    typeController.text = widget.item.type;
    codeController.text = widget.item.code;
    locationController.text = widget.item.location;
    status = widget.item.status;
  }

  updateItem() async {
    await http.put(
      Uri.parse("$baseUrl/update-item/${widget.item.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "type": typeController.text,
        "code": codeController.text,
        "status": status,
        "location": locationController.text,
      }),
    );

    Navigator.pop(context);
  }

  deleteItem() async {
    await http.delete(
      Uri.parse("$baseUrl/delete-item/${widget.item.id}"),
    );

    Navigator.pop(context);
  }

  Widget buildInput(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, Color color, Function onPressed) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => onPressed(),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขครุภัณฑ์"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [

              widget.item.image != null && widget.item.image != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "$baseUrl/uploads/${widget.item.image}",
                        height: 120,
                        fit: BoxFit.cover,
                        headers: {
                          "ngrok-skip-browser-warning": "true",
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 120,
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
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 120),
                      ),
                    )
                  : Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.devices,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    ),

            SizedBox(height: 20),

            buildInput("ชื่อครุภัณฑ์", nameController),

            buildInput("ประเภท", typeController),

            buildInput("รหัสครุภัณฑ์ (QR Code)", codeController),

            buildInput("สถานที่", locationController),

            DropdownButtonFormField(
              value: status,
              decoration: InputDecoration(
                labelText: "สถานะ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: "ปกติ",
                  child: Text("ปกติ"),
                ),
                DropdownMenuItem(
                  value: "ชำรุดรอซ่อม",
                  child: Text("ชำรุดรอซ่อม"),
                ),
                DropdownMenuItem(
                  value: "จำหน่ายออก",
                  child: Text("จำหน่ายออก"),
                ),
              ],
              onChanged: (v) {
                setState(() {
                  status = v.toString();
                });
              },
            ),

            SizedBox(height: 30),

            Row(
              children: [

                buildButton(
                  "บันทึก",
                  Colors.blue,
                  updateItem,
                ),

                SizedBox(width: 10),

                buildButton(
                  "ยกเลิก",
                  Colors.grey,
                  () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}