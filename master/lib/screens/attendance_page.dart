import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // هذي قائمة السجلات بعد التحميل
  List<String> filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  Future<void> _loadAttendanceRecords() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. جلب الإيميل المسجل
    final String? email = prefs.getString('email');
    print('🔍 Loaded email from prefs: $email');

    // 2. بناء المفتاح الخاص بالسجلات
    final key = 'attendanceRecords_$email';
    print('🔑 Looking for key: $key');

    // 3. استرجاع السجلات (قد تكون null)
    final List<String>? records = prefs.getStringList(key);
    print('✅ Records under key "$key": $records');

    // 4. تأكد من عدم تسبب null في أي انهيار
    final safeRecords = records ?? [];

    // 5. حدّث القائمة
    setState(() {
      filteredRecords = safeRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFD),
      appBar: _buildAppBar('Attendance Records'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            Expanded(
              child: filteredRecords.isEmpty
                  ? Center(child: Text('No records found.'))
                  : ListView.separated(
                      itemCount: filteredRecords.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        return _buildAttendanceCard(filteredRecords[index]);
                      },
                    ),
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
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF43A047),
      elevation: 0,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      toolbarHeight: 80,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHeaderItem('Date', Icons.calendar_today),
            _buildHeaderItem('Clock In', Icons.login),
            _buildHeaderItem('Clock Out', Icons.logout),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderItem(String text, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF1976D2)),
        SizedBox(height: 4),
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
      ],
    );
  }

  Widget _buildAttendanceCard(String record) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          record,
          style: _buildTextStyle(),
        ),
      ),
    );
  }

  TextStyle _buildTextStyle() => TextStyle(fontSize: 16, color: Color(0xFF2C3E50));
}
