import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'clock_page.dart';
import 'attendance_page.dart';
import 'leave_page.dart';
import 'reports_page.dart';
import 'dart:math' as math;


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFD),
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 32),
            Expanded(
              child: _buildFeatureGrid(context),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildActionButtons(context),
    );
  }

  // بناء شريط التطبيق
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'SMART PUNCH',
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

  // قسم الترحيب
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back,',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Ready to manage your workday?',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7F8C8D),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // بناء شبكة الخيارات
  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      children: [
        _buildFeatureCard(
          context: context,
          icon: Icons.fingerprint,
          label: 'Clock In/Out',
          iconColor: Color(0xFF1976D2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Colors.white],
          ),
          targetPage: ClockPage(),
        ),
        _buildFeatureCard(
          context: context,
          icon: Icons.calendar_month_rounded,
          label: 'Attendance',
          iconColor: Color(0xFF43A047),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5E9), Colors.white],
          ),
          targetPage: AttendancePage(),
        ),
        _buildFeatureCard(
          context: context,
          icon: Icons.airplane_ticket_rounded,
          label: 'Leave Request',
          iconColor: Color(0xFF7B1FA2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3E5F5), Colors.white],
          ),
          targetPage: LeavePage(),
        ),
        _buildFeatureCard(
          context: context,
          icon: Icons.analytics_rounded,
          label: 'Reports',
          iconColor: Color(0xFFE64A19),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFBE9E7), Colors.white],
          ),
          targetPage: ReportsPage(),
        ),
      ],
    );
  }

// بناء بطاقة الخيار
Widget _buildFeatureCard({
  required BuildContext context,
  required IconData icon,
  required String label,
  required Color iconColor,
  required Gradient gradient,
  required Widget targetPage,
}) {
  return Material(
    borderRadius: BorderRadius.circular(24),
    elevation: 0,
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      splashColor: iconColor.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 1,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16, // Changed from right to left
              child: Icon(
                Icons.arrow_back_ios_rounded, // Changed to arrow_back_ios_rounded
                size: 16,
                color: Colors.grey[400],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 30,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF34495E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
// زر الذهاب إلى الصفحة الشخصية وزر الخروج
Widget _buildActionButtons(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: FloatingActionButton(
          heroTag: 'logoutButton',
          onPressed: () {
            _showLogoutConfirmation(context);
          },
          backgroundColor: Color(0xFFE53935),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi), // يعكس الأيقونة أفقياً
            child: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ),
      ),
      FloatingActionButton(
        heroTag: 'profileButton',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
        backgroundColor: Color(0xFF1976D2),
        child: Icon(Icons.person, color: Colors.white),
      ),
    ],
  );
}

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Logout", style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Add your logout functionality here
                Navigator.of(context).pop();
                // Example: Navigator.pushReplacement to login page
              },
            ),
          ],
        );
      },
    );
  }
}