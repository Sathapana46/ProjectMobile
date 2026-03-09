import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {

  static const String baseUrl =
      "https://teresa-semiradical-odilia.ngrok-free.dev";

  // ===============================
  // SEARCH ITEM BY QR / BARCODE
  // ===============================
  static Future<Item?> searchItem(String code) async {

    // encode barcode ป้องกัน / ใน code
    final encodedCode = Uri.encodeComponent(code);

    final res = await http.get(
      Uri.parse("$baseUrl/items/$encodedCode"),
      headers: {
        "ngrok-skip-browser-warning": "true"
      },
    );

    if (res.statusCode == 200) {

      var data = jsonDecode(res.body);

      if (data["status"] == "not found") {
        return null;
      }

      return Item.fromJson(data);
    }

    return null;
  }

  // ===============================
  // LOGIN
  // ===============================
  static Future<bool> login(String username, String password) async {

    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password
      }),
    );

    var data = jsonDecode(res.body);

    return data["status"] == "success";
  }

  // ===============================
  // REGISTER
  // ===============================
  static Future<bool> register(
      String username,
      String password,
      String fullname) async {

    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "fullname": fullname
      }),
    );

    var data = jsonDecode(res.body);

    return data["status"] == "success";
  }

  // ===============================
  // GET ALL ITEMS
  // ===============================
  static Future<List<Item>> getItems() async {

    final res = await http.get(
      Uri.parse("$baseUrl/items"),
      headers: {
        "ngrok-skip-browser-warning": "true"
      },
    );

    if (res.statusCode == 200) {

      List data = jsonDecode(res.body);

      return data.map((e) => Item.fromJson(e)).toList();
    }

    throw Exception("Failed to load items");
  }

  // ===============================
  // ADD ITEM
  // ===============================
  static Future<bool> addItem(String name, String code) async {

    final res = await http.post(
      Uri.parse("$baseUrl/items"),
      headers: {
        "ngrok-skip-browser-warning": "true"
      },
      body: {
        "name": name,
        "code": code
      },
    );

    return res.statusCode == 200;
  }

  static Future deleteItem(id) async {
    await http.delete(Uri.parse("$baseUrl/delete-item/$id"));
  }


}
