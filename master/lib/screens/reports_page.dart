import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFD),
      appBar: _buildAppBar('Reports'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSummaryCards(),
              SizedBox(height: 24),
              _buildAttendanceChart(),
            ],
          ),
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
      backgroundColor: Color(0xFFE64A19),
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

  Widget _buildSummaryCards() {
    return SizedBox(
      height: 400, // Fixed height for the grid view
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
        crossAxisCount: 2,
        childAspectRatio: 1.0, // Adjusted aspect ratio for taller cards
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildStatCard('Days Present', '22', Icons.check_circle, Color(0xFF43A047)),
          _buildStatCard('Days Absent', '3', Icons.cancel, Color(0xFFE53935)),
          _buildStatCard('Leave Days', '5', Icons.airplanemode_active, Color(0xFF1976D2)),
          _buildStatCard('Late Arrivals', '2', Icons.watch_later, Color(0xFFFB8C00)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Better space distribution
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28), // Larger icon
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 28, // Larger font size
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
            ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 16, // Slightly larger font
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 250, // Increased height
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Attendance Chart Will Appear Here',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}