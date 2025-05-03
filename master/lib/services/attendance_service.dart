import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceService {
  static Future<void> checkInOrOut(String token) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/attendances'); // غيّري للرابط حسب بيئة Laravel

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('✅ Check-in/Check-out: ${data["message"]}');
    } else {
      try {
        final data = jsonDecode(response.body);
        print('❌ Error: ${data["message"]}');
      } catch (_) {
        print('❌ Failed to decode error response.');
      }
    }
  }
}
