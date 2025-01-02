import 'dart:convert';
import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<List<int>> getUserIds() async {
    final response = await http.get(Uri.parse('$baseUrl/users/ids'), headers: {
      'Content-Type': 'application/json',
    });

    log(response.body);

    List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((e) => e as int).toList();
  }
}
