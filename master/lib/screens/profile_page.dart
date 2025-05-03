import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _email = "user@example.com";
  String _name = "John Doe";
  String _role = "Employee";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
  title: Text('My Profile'),
  centerTitle: true,
  backgroundColor: Color(0xFF1976D2),
  elevation: 0,
  shape: ContinuousRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  ),
  titleTextStyle: TextStyle(
    color: Colors.white,  
    fontSize: 20,
    fontWeight: FontWeight.w700,
  ),
),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://example.com/storage/app/public/avatars/user.jpg',
                    ),
                    onBackgroundImageError: (_, __) {
                      // Placeholder if image fails to load
                    },
                  ),
              
                ],
              ),
              SizedBox(height: 24),
              _buildProfileInfoCard(),
              SizedBox(height: 24),
              _buildPasswordChangeCard(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save changes
                  }
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
               child: Text(
  'Save Changes',
  style: TextStyle(
    fontSize: 16,
    color: Colors.white,  
),

              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProfileInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Full Name'),
              subtitle: Text(_name),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditDialog('Name', _name, (value) {
                    setState(() => _name = value);
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.work, color: Colors.blue),
              title: Text('Role'),
              subtitle: Text(_role),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Email'),
              subtitle: Text(_email),
            
                
              ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordChangeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String field, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'New $field',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}