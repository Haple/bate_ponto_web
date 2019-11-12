import 'package:hive/hive.dart';

Future<String> getToken() async {
  var box = await Hive.openBox('myBox');
  return box.get('token');
}
