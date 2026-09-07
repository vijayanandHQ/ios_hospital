import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  List<dynamic> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      final response = await ApiService.getPatientAppointments();
      if (response.statusCode == 200) {
        setState(() {
          _appointments = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() { _isLoading = false; });
      }
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  void _logout() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Appointments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : _appointments.isEmpty
              ? const Center(child: Text('No appointments found.', style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    final apt = _appointments[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.purple.shade100),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple.shade50,
                          radius: 25,
                          child: const Icon(Icons.calendar_month, color: Colors.purple),
                        ),
                        title: Text('Doctor ID: ${apt['doctorId']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Date: ${apt['appointmentDate']}\nSlot: ${apt['timeSlotId']}'),
                        ),
                        trailing: Chip(
                          label: Text(
                            apt['status'] ?? 'PENDING',
                            style: TextStyle(
                              fontSize: 12,
                              color: apt['status'] == 'COMPLETED' ? Colors.green.shade700 : Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: apt['status'] == 'COMPLETED' ? Colors.green.shade50 : Colors.orange.shade50,
                          side: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}