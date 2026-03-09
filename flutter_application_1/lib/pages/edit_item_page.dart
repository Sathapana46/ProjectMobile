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

  String status = "ใช้งาน";

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

            Image.asset(
              "assets/desk.jpg",
              height: 120,
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
                  value: "ใช้งาน",
                  child: Text("ใช้งานได้"),
                ),
                DropdownMenuItem(
                  value: "ซ่อม",
                  child: Text("ซ่อม"),
                ),
                DropdownMenuItem(
                  value: "เสีย",
                  child: Text("เสีย"),
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