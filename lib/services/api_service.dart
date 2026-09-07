import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login'); 
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': email, 
        'password': password,
      }),
    );
    return response;
  }

  static Future<void> saveToken(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('user_role', role);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
  
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // நோயாளியின் முன்பதிவுகளை எடுக்கும் API
  static Future<http.Response> getPatientAppointments() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/appointments/patient');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  // டாக்டருக்கான முன்பதிவுகளை எடுக்கும் API
  static Future<http.Response> getDoctorAppointments() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/doctor/appointments/today');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}