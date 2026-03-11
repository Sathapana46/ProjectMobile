import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {

  static const String baseUrl =
      // "https://teresa-semiradical-odilia.ngrok-free.dev";
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
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true"},
      body: jsonEncode({
        "username": username,
        "password": password
      }),
    );
    var data = jsonDecode(res.body);
    return data;
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
// ===============================
// GET USERS
// ===============================
static Future<List<Map<String, dynamic>>> getUsers() async {

  final res = await http.get(
    Uri.parse("$baseUrl/users"),
    headers: {
      "ngrok-skip-browser-warning": "true"
    },
  );

  if (res.statusCode == 200) {

    final List data = jsonDecode(res.body);

    return data.map((e) => Map<String, dynamic>.from(e)).toList();

  } else {
    return [];
  }
}

// ===============================
// ADD USER
// ===============================
static Future<bool> addUser(
  String username,
  String password,
  String role,
) async {

  final res = await http.post(
    Uri.parse("$baseUrl/add-user"),
    headers: {
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true"
    },
    body: jsonEncode({
      "username": username,
      "password": password,
      "role": role
    }),
  );

  return res.statusCode == 200;
}

// ===============================
// DELETE USER
// ===============================
static Future deleteUser(id) async {
  await http.delete(
    Uri.parse("$baseUrl/delete-user/$id"),
    headers: {
      "ngrok-skip-browser-warning": "true"
    },
  );
}

// ===============================
// UPDATE USER
// ===============================
static Future<bool> updateUser(
  int id,
  String username,
  String role,
) async {

  final res = await http.put(
    Uri.parse("$baseUrl/update-user/$id"),
    headers: {
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true"
    },
    body: jsonEncode({
      "username": username,
      "role": role
    }),
  );

  print(res.body);

  return res.statusCode == 200;
}

}
