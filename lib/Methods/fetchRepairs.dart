import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Repair.dart';

Future<List<Repair>> fetchRepairs() async {
  final response = await http.get(Uri.parse(
      'http://avukatraziyegulacaracikyurek.com/backend/fetch_repair.php'));
  print(response.body);
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    return list.map((model) => Repair.fromJson(model)).toList();
  } else {
    throw Exception('Failed to load repairs');
  }
}
