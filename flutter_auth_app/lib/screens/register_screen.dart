import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _agreeTNC = false;

  // 1. Tambahkan semua controller di sini
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Jangan lupa di-dispose
  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container(height: 6, color: const Color(0xFF04325F))),
                      Expanded(flex: 1, child: Container(height: 6, color: const Color(0xFFFFC107))),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/logo.webp', // Sesuaikan dengan nama dan path file logomu
                        height: 60,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Pendaftaran Akun Baru',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF04325F)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lengkapi data diri Anda untuk mendaftar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 32),
                      
                      // Form Fields
                      _buildTextField('Nama Lengkap', _namaController),
                      const SizedBox(height: 16),
                      _buildTextField('Nomor NIK (16 Digit)', _nikController, isNumber: true),
                      const SizedBox(height: 16),
                      _buildTextField('Email', _emailController),
                      const SizedBox(height: 16),
                      _buildTextField('Nomor Telepon', _teleponController, isNumber: true),
                      const SizedBox(height: 16),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Checkbox Syarat & Ketentuan
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _agreeTNC,
                              activeColor: const Color(0xFF04325F),
                              onChanged: (value) {
                                setState(() {
                                  _agreeTNC = value ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                children: const [
                                  TextSpan(text: 'Saya setuju dengan '),
                                  TextSpan(
                                    text: 'Syarat & Ketentuan',
                                    style: TextStyle(
                                      color: Color(0xFF04325F),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity, 
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (_agreeTNC && !_isLoading) ? () async {
                            setState(() => _isLoading = true);

                            final result = await ApiService.register(
                              namaLengkap: _namaController.text,
                              nik: _nikController.text,
                              email: _emailController.text,
                              nomorTelepon: _teleponController.text,
                              password: _passwordController.text,
                            );

                            setState(() => _isLoading = false);

                            if (result['success']) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Pendaftaran Berhasil!'), backgroundColor: Colors.green),
                                );
                                // Langsung arahkan ke MainScreen karena API mereturn Token setelah pendaftaran[cite: 1]
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
                                );
                              }
                            }
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04325F),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isLoading 
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                                ],
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Link Masuk
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun? ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Kembali ke halaman Login
                            },
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Color(0xFF04325F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      ),
    );
  }
}