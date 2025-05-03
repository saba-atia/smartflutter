import 'package:flutter/material.dart';

class LeaveRequest {
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  LeaveRequest({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}

class LeavePage extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _formKey = GlobalKey<FormState>();
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  final _notesController = TextEditingController();
  bool _isSubmitting = false;
  List<LeaveRequest> _leaveRequests = [];
  LeaveRequest? _removedRequest; // To store temporarily removed request

  @override
  void initState() {
    super.initState();
    _loadLeaveRequests();
  }

  void _loadLeaveRequests() async {
    // Don't reload if there's a temporarily removed request
    if (_removedRequest != null) return;

    final fakeData = await fetchLeaveRequests();
    setState(() {
      _leaveRequests = fakeData;
    });
  }

  Future<List<LeaveRequest>> fetchLeaveRequests() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      LeaveRequest(
        type: 'Sick Leave',
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 3),
        status: 'Approved',
      ),
      LeaveRequest(
        type: 'Annual Leave',
        startDate: DateTime(2025, 4, 20),
        endDate: DateTime(2025, 4, 22),
        status: 'Rejected',
      ),
      LeaveRequest(
        type: 'Unpaid Leave',
        startDate: DateTime(2025, 5, 10),
        endDate: DateTime(2025, 5, 12),
        status: 'Pending',
      ),
    ];
  }

  void _submitLeaveRequest() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isSubmitting = false;
        _removedRequest = null; // Reset the removed request

        final newRequest = LeaveRequest(
          type: _leaveType!,
          startDate: _startDate!,
          endDate: _endDate!,
          status: 'Pending',
        );
        _leaveRequests.insert(0, newRequest); // Add at the top
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Leave request submitted successfully'),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _removedRequest = _leaveRequests.removeAt(0); // Save request before removing
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Leave request cancelled')),
            );
          },
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFD),
      appBar: _buildAppBar('Leave Request'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildLeaveTypeDropdown(),
                  SizedBox(height: 20),
                  _buildDatePicker('Start Date', _startDate, (date) {
                    setState(() => _startDate = date);
                  }),
                  SizedBox(height: 20),
                  _buildDatePicker('End Date', _endDate, (date) {
                    setState(() => _endDate = date);
                  }),
                  SizedBox(height: 20),
                  _buildNotesField(),
                  SizedBox(height: 30),
                  _buildSubmitButton(),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Previous Leave Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _leaveRequests.isEmpty
                ? Text('No previous leave requests')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _leaveRequests.length,
                    itemBuilder: (context, index) {
                      final leave = _leaveRequests[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.airplane_ticket, color: Colors.deepPurple),
                          title: Text(leave.type),
                          subtitle: Text(
                            '${leave.startDate.day}/${leave.startDate.month}/${leave.startDate.year} - '
                            '${leave.endDate.day}/${leave.endDate.month}/${leave.endDate.year}',
                          ),
                          trailing: Text(
                            leave.status,
                            style: TextStyle(
                              color: leave.status == 'Approved'
                                  ? Colors.green
                                  : leave.status == 'Rejected'
                                      ? Colors.red
                                      : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color(0xFF7B1FA2),
    );
  }

  Widget _buildLeaveTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Leave Type'),
      value: _leaveType,
      items: [
        DropdownMenuItem(value: 'Sick Leave', child: Text('Sick Leave')),
        DropdownMenuItem(value: 'Annual Leave', child: Text('Annual Leave')),
        DropdownMenuItem(value: 'Unpaid Leave', child: Text('Unpaid Leave')),
      ],
      onChanged: (value) {
        setState(() {
          _leaveType = value;
        });
      },
      validator: (value) => value == null ? 'Please select leave type' : null,
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          date == null
              ? 'Select Date'
              : '${date.day}/${date.month}/${date.year}',
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: InputDecoration(labelText: 'Notes'),
      maxLines: 3,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitLeaveRequest,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF7B1FA2),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isSubmitting
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
              'Submit Request',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
    );
  }
}