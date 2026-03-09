import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';
import '../models/item.dart';
import 'edit_item_page.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code"), backgroundColor: Colors.blue),

      body: Stack(
        children: [
          /// Camera Scanner
          MobileScanner(
            onDetect: (BarcodeCapture capture) async {
              if (scanned) return;

              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;

                if (code != null) {
                  scanned = true;

                  Item? item = await ApiService.searchItem(code);

                  if (item == null) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("ไม่พบข้อมูล"),
                        content: Text("Code: $code"),
                        actions: [
                          TextButton(
                            child: Text("ตกลง"),
                            onPressed: () {
                              Navigator.pop(context);
                              scanned = false;
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditItemPage(item: item),
                      ),
                    );
                    scanned = false;
                  }

                  break;
                }
              }
            },
          ),

          /// Dark overlay
          Container(color: Colors.black.withOpacity(0.6)),

          /// Scan Box
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 4),
              ),
            ),
          ),

          /// Text bottom
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "กำลังสแกน...",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
