import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  static const baseUrl = "https://teresa-semiradical-odilia.ngrok-free.dev";

  // SEARCH ITEM BY QR
  static Future<Item?> searchItem(String code) async {
    final res = await http.get(Uri.parse("$baseUrl/items/$code"));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data["status"] == "not found") {
        return null;
      }

      return Item.fromJson(data);
    }

    return null;
  }

  // LOGIN
  static Future<bool> login(String username, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    var data = jsonDecode(res.body);

    return data["status"] == "success";
  }

  static Future<bool> register(
    String username,
    String password,
    String fullname,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "fullname": fullname,
      }),
    );

    var data = jsonDecode(res.body);

    return data["status"] == "success";
  }

  static Future<List<Item>> getItems() async {
    final res = await http.get(
      Uri.parse("$baseUrl/items"),
      headers: {"ngrok-skip-browser-warning": "true"},
    );

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);

      return data.map((e) => Item.fromJson(e)).toList();
    }

    throw Exception("Failed to load items");
  }

  // ADD ITEM
  static Future addItem(String name, String code) async {
    await http.post(
      Uri.parse("$baseUrl/items"),
      body: {"name": name, "code": code},
    );
  }

  static Future deleteItem(id) async {
    await http.delete(Uri.parse("$baseUrl/delete-item/$id"));
  }

  // SEARCH BY QR
  static Future<Item?> searchByQR(String code) async {
    final res = await http.get(Uri.parse("$baseUrl/items/search/$code"));

    if (res.statusCode == 200) {
      return Item.fromJson(json.decode(res.body));
    }

    return null;
  }
}
