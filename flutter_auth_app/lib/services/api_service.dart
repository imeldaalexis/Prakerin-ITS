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
    final url = Uri.parse('$baseUrl/register'); //
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json', //
          'Content-Type': 'application/json', //[cite: 1]
        },
        body: jsonEncode({
          "nama_lengkap": namaLengkap, //[cite: 1]
          "nik": nik, //[cite: 1]
          "email": email, //[cite: 1]
          "nomor_telepon": nomorTelepon, //[cite: 1]
          "password": password, //[cite: 1]
          "password_confirmation": password, //[cite: 1]
          "is_agreed": true, //[cite: 1]
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) { //[cite: 1]
        // Menyimpan token otomatis agar pengguna tidak perlu login ulang setelah mendaftar[cite: 1]
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['data']['token']); //[cite: 1]
        return {'success': true, 'message': responseData['message']}; //[cite: 1]
      } else {
        // Response Gagal - Validasi 422 Unprocessable Entity[cite: 1]
        return {'success': false, 'message': responseData['message'] ?? 'Data tidak valid'}; //[cite: 1]
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
    final url = Uri.parse('$baseUrl/login'); //[cite: 1]

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json', //[cite: 1]
          'Content-Type': 'application/json', //[cite: 1]
        },
        body: jsonEncode({
          "login_id": loginId, //[cite: 1]
          "password": password, //[cite: 1]
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) { //[cite: 1]
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['data']['token']); //[cite: 1]
        return {'success': true, 'message': responseData['message']}; //[cite: 1]
      } else {
         // Response Gagal - Kredensial Salah 401 Unauthorized[cite: 1]
        return {'success': false, 'message': responseData['message'] ?? 'Login Gagal'}; //[cite: 1]
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
}