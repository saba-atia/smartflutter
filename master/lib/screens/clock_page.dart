import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  final String apiUrl = 'https://your-api-url.com/api/attendance';

  Future<void> _saveAttendanceRecord(String clockType) async {
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('email') ?? 'unknown';

    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year}';
    final formattedTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    final key = 'attendanceRecords_$email';

    List<String> records = prefs.getStringList(key) ?? [];

    records.add('$formattedDate - $clockType at $formattedTime');

    await prefs.setStringList(key, records);
  }

  Future<void> _recordAttendance(String type) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'type': type,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _showCustomSnackbar(
          message: '$type successful!',
          icon: Icons.check_circle,
          backgroundColor: Colors.green.shade600,
        );
      } else {
        _showCustomSnackbar(
          message: 'Failed to $type. Please try again.',
          icon: Icons.error_outline,
          backgroundColor: Colors.red.shade600,
        );
      }
    } catch (e) {
      _showCustomSnackbar(
        message: 'Could not connect to the server.',
        icon: Icons.wifi_off,
        backgroundColor: Colors.red.shade700,
      );
    }
  }

  void _showCustomSnackbar({
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFD),
      appBar: _buildAppBar('Clock In/Out'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDateTimeSection(),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildClockButton(
                  'Clock In',
                  Icons.login,
                  Color(0xFF43A047),
                  onPressed: () {
                    _saveAttendanceRecord('Clock In');
                    _recordAttendance('Clock In');
                  },
                ),
                SizedBox(width: 20),
                _buildClockButton(
                  'Clock Out',
                  Icons.logout,
                  Color(0xFFDD4B39),
                  onPressed: () {
                    _saveAttendanceRecord('Clock Out');
                    _recordAttendance('Clock Out');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF1976D2),
      elevation: 0,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      toolbarHeight: 80,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _buildDateTimeSection() {
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    final date = '${now.day}/${now.month}/${now.year}';

    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 8),
        Text(
          date,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }

  Widget _buildClockButton(String text, IconData icon, Color color, {VoidCallback? onPressed}) {
    return SizedBox(
      width: 150,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
