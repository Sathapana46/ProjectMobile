import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {

  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final typeController = TextEditingController();
  final locationController = TextEditingController();

  String status = "ใช้งาน";
  File? imageFile;

  final picker = ImagePicker();

  final baseUrl = "https://teresa-semiradical-odilia.ngrok-free.dev";

  /// =============================
  /// Scan QR
  /// =============================
  Future scanQR() async {
    final code = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Scan QR Code")),
          body: MobileScanner(
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  Navigator.pop(context, code);
                  break;
                }
              }
            },
          ),
        ),
      ),
    );
    if (code != null) {
      setState(() {
        codeController.text = code;
      });
    }
  }

  /// =============================
  /// เปิดกล้อง
  /// =============================
  Future pickCamera() async {

    var status = await Permission.camera.request();

    if (status.isGranted) {

      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {

        setState(() {
          imageFile = File(image.path);
        });

      }

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("กรุณาอนุญาตการใช้กล้อง"),
        ),
      );

    }

  }

  /// =============================
  /// เปิด Gallery
  /// =============================
  Future pickGallery() async {

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {

      setState(() {
        imageFile = File(image.path);
      });

    }

  }

  /// =============================
  /// เลือก Camera หรือ Gallery
  /// =============================
  Future chooseImage() async {

    showModalBottomSheet(
      context: context,
      builder: (_) {

        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("ถ่ายรูป"),
                onTap: () {
                  Navigator.pop(context);
                  pickCamera();
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("เลือกรูปจากเครื่อง"),
                onTap: () {
                  Navigator.pop(context);
                  pickGallery();
                },
              ),

            ],
          ),
        );

      },
    );

  }

  /// =============================
  /// ส่งข้อมูลไป Backend
  /// =============================
  Future addItem() async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/add-item"),
    );

    request.fields["name"] = nameController.text;
    request.fields["type"] = typeController.text;
    request.fields["code"] = codeController.text;
    request.fields["status"] = status;
    request.fields["location"] = locationController.text;

    if (imageFile != null) {

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          imageFile!.path,
        ),
      );

    }

    await request.send();

    Navigator.pop(context);

  }

  /// =============================
  /// input field
  /// =============================
  Widget inputField(String label, TextEditingController controller) {

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("เพิ่มครุภัณฑ์"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            /// =====================
            /// Upload Image
            /// =====================
            GestureDetector(

              onTap: chooseImage,

              child: Container(

                height: 140,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: imageFile == null

                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [

                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.blue,
                          ),

                          SizedBox(height: 6),

                          Text("อัพโหลดรูปหรือถ่ายครุภัณฑ์"),

                        ],
                      )

                    : ClipRRect(

                        borderRadius: BorderRadius.circular(18),

                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),

                      ),

              ),

            ),

            const SizedBox(height: 25),

            inputField("ชื่อ", nameController),
            const SizedBox(height: 10),

            inputField("ประเภท", typeController),
            const SizedBox(height: 10),

            /// =====================
            /// Code + Scan QR
            /// =====================
            TextField(

              controller: codeController,

              decoration: InputDecoration(

                labelText: "รหัสสินค้า",

                border: const UnderlineInputBorder(),

                suffixIcon: IconButton(

                  icon: const Icon(Icons.qr_code_scanner),

                  onPressed: scanQR,

                ),

              ),

            ),

            const SizedBox(height: 10),

            inputField("Location", locationController),

            const SizedBox(height: 10),

            /// =====================
            /// Status Dropdown
            /// =====================
            DropdownButtonFormField(

              value: status,

              decoration: const InputDecoration(
                labelText: "สถานะ",
                border: UnderlineInputBorder(),
              ),

              items: const [

                DropdownMenuItem(
                  value: "ใช้งาน",
                  child: Text("ใช้งาน"),
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

            const SizedBox(height: 35),

            /// =====================
            /// Buttons
            /// =====================
            Row(

              children: [

                Expanded(

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      "ยกเลิก",
                      style: TextStyle(fontSize: 16),
                    ),

                  ),

                ),

                const SizedBox(width: 12),

                Expanded(

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),

                    onPressed: addItem,

                    child: const Text(
                      "บันทึก",
                      style: TextStyle(fontSize: 16),
                    ),

                  ),

                ),

              ],

            ),

          ],

        ),

      ),

    );

  }
}