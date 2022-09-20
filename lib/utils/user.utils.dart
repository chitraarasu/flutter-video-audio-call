import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

Future<String> loadUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId;
  if (prefs.containsKey("userId")) {
    userId = prefs.getString("userId");
  } else {
    userId = uuid.v4();
    prefs.setString("userId", userId);
  }
  return userId;
}
