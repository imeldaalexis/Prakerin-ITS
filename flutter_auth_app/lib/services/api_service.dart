import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Ganti IP ini. Jika pakai Android Emulator, gunakan 10.0.2.2.
  // Jika pakai device asli/web, gunakan IP komputermu (misal: 192.168.x.x)
  static const String baseUrl = 'http://10.0.2.2:8000/api/auth';

  // ==========================================
  // 1. Fungsi Register
  // ==========================================
  static Future<Map<String, dynamic>> register({
    required String namaLengkap,
    required String nik,
    required String email,
    required String nomorTelepon,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "nama_lengkap": namaLengkap,
          "nik": nik,
          "email": email,
          "nomor_telepon": nomorTelepon,
          "password": password,
          "password_confirmation": password,
          "is_agreed": true,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['data']['token']);
        if (responseData['data']['user'] != null) {
          await prefs.setString('user_data', jsonEncode(responseData['data']['user']));
        }
        return {'success': true, 'message': responseData['message']};
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Data tidak valid'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  // ==========================================
  // 2. Fungsi Login
  // ==========================================
  static Future<Map<String, dynamic>> login({
    required String loginId,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "login_id": loginId,
          "password": password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['data']['token']);
        if (responseData['data']['user'] != null) {
          await prefs.setString('user_data', jsonEncode(responseData['data']['user']));
        }
        return {'success': true, 'message': responseData['message']};
      } else {
        return {'success': false, 'message': responseData['message'] ?? 'Login Gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  // ==========================================
  // 3. Fungsi Logout
  // ==========================================
  static Future<Map<String, dynamic>> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      // Hapus token dan user_data dari SharedPreferences terlepas dari response status
      await prefs.remove('token');
      await prefs.remove('user_data');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'message': responseData['message'] ?? 'Logout berhasil'};
      } else {
        return {'success': true, 'message': 'Logout selesai'};
      }
    } catch (e) {
      await prefs.remove('token');
      await prefs.remove('user_data');
      return {'success': true, 'message': 'Logout lokal selesai'};
    }
  }

  // ==========================================
  // 4. Ambil User Data Terformat
  // ==========================================
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user_data');
    if (userJson != null) {
      try {
        return jsonDecode(userJson) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}